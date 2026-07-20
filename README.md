# image_operation_rust_poc

Flutter + Rust FFI Proof of Concept: decode → resize → JPEG encode using
`flutter_rust_bridge` v2, `image`, and `fast_image_resize`.

| Piece | Name |
|---|---|
| Flutter app | `image_operation_rust` |
| Rust crate | `native_image_processor` |
| PoC root | `image_operation_rust_poc` |

## Demo

https://github.com/JamEvolution/image_operation_rust_poc/raw/master/demo/poc_demo.mov

## Prerequisites

```bash
# Flutter (FVM or system)
flutter --version

# Rust toolchain
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source "$HOME/.cargo/env"

# Mobile targets (optional, as needed)
rustup target add aarch64-apple-ios aarch64-apple-ios-sim
rustup target add aarch64-linux-android armv7-linux-androideabi \
  i686-linux-android x86_64-linux-android

# FRB codegen
cargo install flutter_rust_bridge_codegen --locked
cargo install cargo-expand
```

## Create from scratch (reference)

```bash
cd ~/Out-Projects
flutter_rust_bridge_codegen create image_operation_rust \
  --rust-crate-name native_image_processor \
  --org com.poc
mv image_operation_rust image_operation_rust_poc
cd image_operation_rust_poc
```

## After editing Rust API

```bash
cd ~/Out-Projects/image_operation_rust_poc
flutter_rust_bridge_codegen generate
cd rust && cargo check && cd ..
flutter pub get
```

## Run

```bash
# macOS
flutter run -d macos

# iOS simulator
flutter run -d ios

# Android
flutter run -d android
```

## What to verify in the UI

1. Spinner at the top keeps rotating (UI thread is free).
2. Pick a high-res gallery photo → see original MB + resolution.
3. Tap **Process with Rust FFI** → elapsed ms, new size, preview.

Rust `process_image` is **async** (no `#[frb(sync)]`), so FRB runs it on a
worker pool and does not block the Flutter UI isolate.
