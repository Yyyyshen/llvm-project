; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S %s -scalarize-masked-mem-intrin -mtriple=aarch64-linux-gnu | FileCheck -check-prefixes=CHECK,CHECK-LE %s
; RUN: opt -S %s -scalarize-masked-mem-intrin -mtriple=aarch64-linux-gnu -mattr=+sve | FileCheck -check-prefixes=CHECK,CHECK-LE %s
; RUN: opt -S %s -scalarize-masked-mem-intrin -mtriple=aarch64_be-linux-gnu -data-layout="E-m:o-i64:64-i128:128-n32:64-S128" | FileCheck -check-prefixes=CHECK,CHECK-BE %s

define void @scalarize_v2i64(<2 x i64>* %p, <2 x i1> %mask, <2 x i64> %data) {
; CHECK-LE-LABEL: @scalarize_v2i64(
; CHECK-LE-NEXT:    [[TMP1:%.*]] = bitcast <2 x i64>* [[P:%.*]] to i64*
; CHECK-LE-NEXT:    [[SCALAR_MASK:%.*]] = bitcast <2 x i1> [[MASK:%.*]] to i2
; CHECK-LE-NEXT:    [[TMP2:%.*]] = and i2 [[SCALAR_MASK]], 1
; CHECK-LE-NEXT:    [[TMP3:%.*]] = icmp ne i2 [[TMP2]], 0
; CHECK-LE-NEXT:    br i1 [[TMP3]], label [[COND_STORE:%.*]], label [[ELSE:%.*]]
; CHECK-LE:       cond.store:
; CHECK-LE-NEXT:    [[TMP4:%.*]] = extractelement <2 x i64> [[DATA:%.*]], i64 0
; CHECK-LE-NEXT:    [[TMP5:%.*]] = getelementptr inbounds i64, i64* [[TMP1]], i32 0
; CHECK-LE-NEXT:    store i64 [[TMP4]], i64* [[TMP5]], align 8
; CHECK-LE-NEXT:    br label [[ELSE]]
; CHECK-LE:       else:
; CHECK-LE-NEXT:    [[TMP6:%.*]] = and i2 [[SCALAR_MASK]], -2
; CHECK-LE-NEXT:    [[TMP7:%.*]] = icmp ne i2 [[TMP6]], 0
; CHECK-LE-NEXT:    br i1 [[TMP7]], label [[COND_STORE1:%.*]], label [[ELSE2:%.*]]
; CHECK-LE:       cond.store1:
; CHECK-LE-NEXT:    [[TMP8:%.*]] = extractelement <2 x i64> [[DATA]], i64 1
; CHECK-LE-NEXT:    [[TMP9:%.*]] = getelementptr inbounds i64, i64* [[TMP1]], i32 1
; CHECK-LE-NEXT:    store i64 [[TMP8]], i64* [[TMP9]], align 8
; CHECK-LE-NEXT:    br label [[ELSE2]]
; CHECK-LE:       else2:
; CHECK-LE-NEXT:    ret void
;
; CHECK-BE-LABEL: @scalarize_v2i64(
; CHECK-BE-NEXT:    [[TMP1:%.*]] = bitcast <2 x i64>* [[P:%.*]] to i64*
; CHECK-BE-NEXT:    [[SCALAR_MASK:%.*]] = bitcast <2 x i1> [[MASK:%.*]] to i2
; CHECK-BE-NEXT:    [[TMP2:%.*]] = and i2 [[SCALAR_MASK]], -2
; CHECK-BE-NEXT:    [[TMP3:%.*]] = icmp ne i2 [[TMP2]], 0
; CHECK-BE-NEXT:    br i1 [[TMP3]], label [[COND_STORE:%.*]], label [[ELSE:%.*]]
; CHECK-BE:       cond.store:
; CHECK-BE-NEXT:    [[TMP4:%.*]] = extractelement <2 x i64> [[DATA:%.*]], i64 0
; CHECK-BE-NEXT:    [[TMP5:%.*]] = getelementptr inbounds i64, i64* [[TMP1]], i32 0
; CHECK-BE-NEXT:    store i64 [[TMP4]], i64* [[TMP5]], align 8
; CHECK-BE-NEXT:    br label [[ELSE]]
; CHECK-BE:       else:
; CHECK-BE-NEXT:    [[TMP6:%.*]] = and i2 [[SCALAR_MASK]], 1
; CHECK-BE-NEXT:    [[TMP7:%.*]] = icmp ne i2 [[TMP6]], 0
; CHECK-BE-NEXT:    br i1 [[TMP7]], label [[COND_STORE1:%.*]], label [[ELSE2:%.*]]
; CHECK-BE:       cond.store1:
; CHECK-BE-NEXT:    [[TMP8:%.*]] = extractelement <2 x i64> [[DATA]], i64 1
; CHECK-BE-NEXT:    [[TMP9:%.*]] = getelementptr inbounds i64, i64* [[TMP1]], i32 1
; CHECK-BE-NEXT:    store i64 [[TMP8]], i64* [[TMP9]], align 8
; CHECK-BE-NEXT:    br label [[ELSE2]]
; CHECK-BE:       else2:
; CHECK-BE-NEXT:    ret void
;
  call void @llvm.masked.store.v2i64.p0v2i64(<2 x i64> %data, <2 x i64>* %p, i32 128, <2 x i1> %mask)
  ret void
}

define void @scalarize_v2i64_ones_mask(<2 x i64>* %p, <2 x i64> %data) {
; CHECK-LABEL: @scalarize_v2i64_ones_mask(
; CHECK-NEXT:    store <2 x i64> [[DATA:%.*]], <2 x i64>* [[P:%.*]], align 8
; CHECK-NEXT:    ret void
;
  call void @llvm.masked.store.v2i64.p0v2i64(<2 x i64> %data, <2 x i64>* %p, i32 8, <2 x i1> <i1 true, i1 true>)
  ret void
}

define void @scalarize_v2i64_zero_mask(<2 x i64>* %p, <2 x i64> %data) {
; CHECK-LABEL: @scalarize_v2i64_zero_mask(
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast <2 x i64>* [[P:%.*]] to i64*
; CHECK-NEXT:    ret void
;
  call void @llvm.masked.store.v2i64.p0v2i64(<2 x i64> %data, <2 x i64>* %p, i32 8, <2 x i1> <i1 false, i1 false>)
  ret void
}

define void @scalarize_v2i64_const_mask(<2 x i64>* %p, <2 x i64> %data) {
; CHECK-LABEL: @scalarize_v2i64_const_mask(
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast <2 x i64>* [[P:%.*]] to i64*
; CHECK-NEXT:    [[TMP2:%.*]] = extractelement <2 x i64> [[DATA:%.*]], i64 1
; CHECK-NEXT:    [[TMP3:%.*]] = getelementptr inbounds i64, i64* [[TMP1]], i32 1
; CHECK-NEXT:    store i64 [[TMP2]], i64* [[TMP3]], align 8
; CHECK-NEXT:    ret void
;
  call void @llvm.masked.store.v2i64.p0v2i64(<2 x i64> %data, <2 x i64>* %p, i32 8, <2 x i1> <i1 false, i1 true>)
  ret void
}

declare void @llvm.masked.store.v2i64.p0v2i64(<2 x i64>, <2 x i64>*, i32, <2 x i1>)
