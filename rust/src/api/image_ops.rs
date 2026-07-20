use fast_image_resize::images::Image;
use fast_image_resize::{FilterType, PixelType, ResizeAlg, ResizeOptions, Resizer};
use image::codecs::jpeg::JpegEncoder;
use image::{DynamicImage, ExtendedColorType, ImageEncoder, ImageReader};
use std::io::Cursor;

/// Decodes image bytes, resizes to the target dimensions, and encodes as JPEG.
/// Async (non-`sync`) so flutter_rust_bridge runs it off the UI isolate.
pub fn process_image(
    image_bytes: Vec<u8>,
    target_width: u32,
    target_height: u32,
    quality: u8,
) -> Result<Vec<u8>, String> {
    validate_process_image_input(target_width, target_height, quality)?;
    let source_rgba: image::RgbaImage = decode_image_as_rgba(&image_bytes)?;
    let resized_rgba: Image<'static> =
        resize_rgba_image(&source_rgba, target_width, target_height)?;
    encode_jpeg_bytes(&resized_rgba, quality)
}

fn validate_process_image_input(
    target_width: u32,
    target_height: u32,
    quality: u8,
) -> Result<(), String> {
    if target_width == 0 || target_height == 0 {
        return Err("Target width and height must be greater than zero.".to_string());
    }
    if quality == 0 || quality > 100 {
        return Err("JPEG quality must be in the range 1..=100.".to_string());
    }
    Ok(())
}

fn decode_image_as_rgba(image_bytes: &[u8]) -> Result<image::RgbaImage, String> {
    let reader = ImageReader::new(Cursor::new(image_bytes))
        .with_guessed_format()
        .map_err(|err| format!("Failed to inspect image format: {err}"))?;
    let dynamic_image: DynamicImage = reader
        .decode()
        .map_err(|err| format!("Failed to decode image: {err}"))?;
    Ok(dynamic_image.to_rgba8())
}

fn resize_rgba_image(
    source_rgba: &image::RgbaImage,
    target_width: u32,
    target_height: u32,
) -> Result<Image<'static>, String> {
    let source_width: u32 = source_rgba.width();
    let source_height: u32 = source_rgba.height();
    let source_image: Image<'_> = Image::from_vec_u8(
        source_width,
        source_height,
        source_rgba.as_raw().to_vec(),
        PixelType::U8x4,
    )
    .map_err(|err| format!("Failed to wrap source RGBA buffer: {err}"))?;
    let mut destination_image: Image<'static> =
        Image::new(target_width, target_height, PixelType::U8x4);
    let mut resizer: Resizer = Resizer::new();
    let resize_options: ResizeOptions =
        ResizeOptions::new().resize_alg(ResizeAlg::Convolution(FilterType::Lanczos3));
    resizer
        .resize(&source_image, &mut destination_image, &resize_options)
        .map_err(|err| format!("Failed to resize image: {err}"))?;
    Ok(destination_image)
}

fn encode_jpeg_bytes(rgba_image: &Image<'_>, quality: u8) -> Result<Vec<u8>, String> {
    let width: u32 = rgba_image.width();
    let height: u32 = rgba_image.height();
    let rgba = image::RgbaImage::from_raw(width, height, rgba_image.buffer().to_vec())
        .ok_or_else(|| "Failed to create RGBA image for JPEG encoding.".to_string())?;
    let rgb_image = DynamicImage::ImageRgba8(rgba).to_rgb8();
    let mut output: Cursor<Vec<u8>> = Cursor::new(Vec::new());
    let mut encoder: JpegEncoder<&mut Cursor<Vec<u8>>> =
        JpegEncoder::new_with_quality(&mut output, quality);
    encoder
        .write_image(rgb_image.as_raw(), width, height, ExtendedColorType::Rgb8)
        .map_err(|err| format!("Failed to encode JPEG: {err}"))?;
    Ok(output.into_inner())
}

#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    flutter_rust_bridge::setup_default_user_utils();
}
