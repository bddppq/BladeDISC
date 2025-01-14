// RUN: disc-opt -split-input-file %s | FileCheck %s

func.func @main(%arg0: tensor<128x128xf32>) -> tensor<4x4x32x32xf32> {
  %0 = tensor.empty() : tensor<4x4x32x32xf32>
  // CHECK: disc_linalg_ext.multi_level_pack
  %1 = disc_linalg_ext.multi_level_pack %arg0 with tile_levels = [1, 1] tile_sizes = [32, 32] permutation = [0, 2, 1, 3] into %0 : (tensor<128x128xf32> tensor<4x4x32x32xf32>) -> tensor<4x4x32x32xf32>
  return %1 : tensor<4x4x32x32xf32>
}

// -----

// CHECK-LABEL: @const
func.func @const() -> tensor<2x4xf32> {
  %0 = disc_linalg_ext.constant_wrapper dense<[[0.0, 1.0, 2.0, 3.0], [4.0, 5.0, 6.0, 7.0]]> : tensor<2x4xf32>
  return %0 : tensor<2x4xf32>
}

// -----

// CHECK-LABEL: @padding_value_placeholder
func.func @padding_value_placeholder() -> f32 {
  %0 = disc_linalg_ext.padding_value_placeholder padding_mode(kAny), value(0.0 : f32)
  %1 = disc_linalg_ext.padding_value_placeholder padding_mode(kExact), value(0.0 : f32)
  %2 = arith.addf %0, %1 : f32
  return %2 : f32
}
