; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -loop-vectorize -mtriple=x86_64-unknown-linux -S -pass-remarks=loop-vectorize -pass-remarks-missed=loop-vectorize -pass-remarks-analysis=loop-vectorize -pass-remarks-with-hotness 2>&1 | FileCheck %s
; RUN: opt < %s -passes=loop-vectorize -mtriple=x86_64-unknown-linux -S -pass-remarks=loop-vectorize -pass-remarks-missed=loop-vectorize -pass-remarks-analysis=loop-vectorize -pass-remarks-with-hotness 2>&1 | FileCheck %s

; CHECK: remark: no_fpmath.c:6:11: loop not vectorized: cannot prove it is safe to reorder floating-point operations (hotness: 300)
; CHECK: remark: no_fpmath.c:6:14: loop not vectorized
; CHECK: remark: no_fpmath.c:17:14: vectorized loop (vectorization width: 2, interleaved count: 1) (hotness: 300)

target datalayout = "e-m:o-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.10.0"

; Function Attrs: nounwind readonly ssp uwtable
define double @cond_sum(i32* nocapture readonly %v, i32 %n) #0 !dbg !4 !prof !29 {
; CHECK-LABEL: @cond_sum(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP_7:%.*]] = icmp sgt i32 [[N:%.*]], 0, !dbg [[DBG9:![0-9]+]]
; CHECK-NEXT:    br i1 [[CMP_7]], label [[FOR_BODY_PREHEADER:%.*]], label [[FOR_COND_CLEANUP:%.*]], !dbg [[DBG10:![0-9]+]], !prof [[PROF11:![0-9]+]]
; CHECK:       for.body.preheader:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]], !dbg [[DBG12:![0-9]+]]
; CHECK:       for.cond.cleanup.loopexit:
; CHECK-NEXT:    [[ADD_LCSSA:%.*]] = phi double [ [[ADD:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    br label [[FOR_COND_CLEANUP]], !dbg [[DBG13:![0-9]+]]
; CHECK:       for.cond.cleanup:
; CHECK-NEXT:    [[A_0_LCSSA:%.*]] = phi double [ 0.000000e+00, [[ENTRY:%.*]] ], [ [[ADD_LCSSA]], [[FOR_COND_CLEANUP_LOOPEXIT:%.*]] ]
; CHECK-NEXT:    ret double [[A_0_LCSSA]], !dbg [[DBG13]]
; CHECK:       for.body:
; CHECK-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ [[INDVARS_IV_NEXT:%.*]], [[FOR_BODY]] ], [ 0, [[FOR_BODY_PREHEADER]] ]
; CHECK-NEXT:    [[A_08:%.*]] = phi double [ [[ADD]], [[FOR_BODY]] ], [ 0.000000e+00, [[FOR_BODY_PREHEADER]] ]
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i32, i32* [[V:%.*]], i64 [[INDVARS_IV]], !dbg [[DBG12]]
; CHECK-NEXT:    [[TMP0:%.*]] = load i32, i32* [[ARRAYIDX]], align 4, !dbg [[DBG12]], !tbaa [[TBAA14:![0-9]+]]
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i32 [[TMP0]], 0, !dbg [[DBG18:![0-9]+]]
; CHECK-NEXT:    [[COND:%.*]] = select i1 [[CMP1]], double 3.400000e+00, double 1.150000e+00, !dbg [[DBG12]]
; CHECK-NEXT:    [[ADD]] = fadd double [[A_08]], [[COND]], !dbg [[DBG19:![0-9]+]]
; CHECK-NEXT:    [[INDVARS_IV_NEXT]] = add nuw nsw i64 [[INDVARS_IV]], 1, !dbg [[DBG10]]
; CHECK-NEXT:    [[LFTR_WIDEIV:%.*]] = trunc i64 [[INDVARS_IV_NEXT]] to i32, !dbg [[DBG10]]
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i32 [[LFTR_WIDEIV]], [[N]], !dbg [[DBG10]]
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[FOR_COND_CLEANUP_LOOPEXIT]], label [[FOR_BODY]], !dbg [[DBG10]], !prof [[PROF20:![0-9]+]], !llvm.loop [[LOOP21:![0-9]+]]
;
entry:
  %cmp.7 = icmp sgt i32 %n, 0, !dbg !3
  br i1 %cmp.7, label %for.body.preheader, label %for.cond.cleanup, !dbg !8, !prof !30

for.body.preheader:                               ; preds = %entry
  br label %for.body, !dbg !9

for.cond.cleanup.loopexit:                        ; preds = %for.body
  %add.lcssa = phi double [ %add, %for.body ]
  br label %for.cond.cleanup, !dbg !10

for.cond.cleanup:                                 ; preds = %for.cond.cleanup.loopexit, %entry
  %a.0.lcssa = phi double [ 0.000000e+00, %entry ], [ %add.lcssa, %for.cond.cleanup.loopexit ]
  ret double %a.0.lcssa, !dbg !10

for.body:                                         ; preds = %for.body.preheader, %for.body
  %indvars.iv = phi i64 [ %indvars.iv.next, %for.body ], [ 0, %for.body.preheader ]
  %a.08 = phi double [ %add, %for.body ], [ 0.000000e+00, %for.body.preheader ]
  %arrayidx = getelementptr inbounds i32, i32* %v, i64 %indvars.iv, !dbg !9
  %0 = load i32, i32* %arrayidx, align 4, !dbg !9, !tbaa !11
  %cmp1 = icmp eq i32 %0, 0, !dbg !15
  %cond = select i1 %cmp1, double 3.400000e+00, double 1.150000e+00, !dbg !9
  %add = fadd double %a.08, %cond, !dbg !16
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1, !dbg !8
  %lftr.wideiv = trunc i64 %indvars.iv.next to i32, !dbg !8
  %exitcond = icmp eq i32 %lftr.wideiv, %n, !dbg !8
  br i1 %exitcond, label %for.cond.cleanup.loopexit, label %for.body, !dbg !8, !llvm.loop !17, !prof !31
}

; Function Attrs: nounwind readonly ssp uwtable
define double @cond_sum_loop_hint(i32* nocapture readonly %v, i32 %n) #0 !dbg !20 !prof !29{
; CHECK-LABEL: @cond_sum_loop_hint(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP_7:%.*]] = icmp sgt i32 [[N:%.*]], 0, !dbg [[DBG24:![0-9]+]]
; CHECK-NEXT:    br i1 [[CMP_7]], label [[FOR_BODY_PREHEADER:%.*]], label [[FOR_COND_CLEANUP:%.*]], !dbg [[DBG25:![0-9]+]], !prof [[PROF11]]
; CHECK:       for.body.preheader:
; CHECK-NEXT:    [[TMP0:%.*]] = add i32 [[N]], -1, !dbg [[DBG26:![0-9]+]]
; CHECK-NEXT:    [[TMP1:%.*]] = zext i32 [[TMP0]] to i64, !dbg [[DBG26]]
; CHECK-NEXT:    [[TMP2:%.*]] = add nuw nsw i64 [[TMP1]], 1, !dbg [[DBG26]]
; CHECK-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ult i64 [[TMP2]], 2, !dbg [[DBG26]]
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]], !dbg [[DBG26]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[N_MOD_VF:%.*]] = urem i64 [[TMP2]], 2, !dbg [[DBG26]]
; CHECK-NEXT:    [[N_VEC:%.*]] = sub i64 [[TMP2]], [[N_MOD_VF]], !dbg [[DBG26]]
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]], !dbg [[DBG26]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ], !dbg [[DBG25]]
; CHECK-NEXT:    [[VEC_PHI:%.*]] = phi <2 x double> [ <double 0.000000e+00, double -0.000000e+00>, [[VECTOR_PH]] ], [ [[TMP9:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP3:%.*]] = add i64 [[INDEX]], 0
; CHECK-NEXT:    [[TMP4:%.*]] = getelementptr inbounds i32, i32* [[V:%.*]], i64 [[TMP3]], !dbg [[DBG26]]
; CHECK-NEXT:    [[TMP5:%.*]] = getelementptr inbounds i32, i32* [[TMP4]], i32 0, !dbg [[DBG26]]
; CHECK-NEXT:    [[TMP6:%.*]] = bitcast i32* [[TMP5]] to <2 x i32>*, !dbg [[DBG26]]
; CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <2 x i32>, <2 x i32>* [[TMP6]], align 4, !dbg [[DBG26]], !tbaa [[TBAA14]]
; CHECK-NEXT:    [[TMP7:%.*]] = icmp eq <2 x i32> [[WIDE_LOAD]], zeroinitializer, !dbg [[DBG27:![0-9]+]]
; CHECK-NEXT:    [[TMP8:%.*]] = select <2 x i1> [[TMP7]], <2 x double> <double 3.400000e+00, double 3.400000e+00>, <2 x double> <double 1.150000e+00, double 1.150000e+00>, !dbg [[DBG26]]
; CHECK-NEXT:    [[TMP9]] = fadd <2 x double> [[VEC_PHI]], [[TMP8]], !dbg [[DBG28:![0-9]+]]
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], 2, !dbg [[DBG25]]
; CHECK-NEXT:    [[TMP10:%.*]] = icmp eq i64 [[INDEX_NEXT]], [[N_VEC]], !dbg [[DBG25]]
; CHECK-NEXT:    br i1 [[TMP10]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !dbg [[DBG25]], !prof [[PROF29:![0-9]+]], !llvm.loop [[LOOP30:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[TMP11:%.*]] = call double @llvm.vector.reduce.fadd.v2f64(double -0.000000e+00, <2 x double> [[TMP9]]), !dbg [[DBG25]]
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 [[TMP2]], [[N_VEC]], !dbg [[DBG25]]
; CHECK-NEXT:    br i1 [[CMP_N]], label [[FOR_COND_CLEANUP_LOOPEXIT:%.*]], label [[SCALAR_PH]], !dbg [[DBG25]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ [[N_VEC]], [[MIDDLE_BLOCK]] ], [ 0, [[FOR_BODY_PREHEADER]] ]
; CHECK-NEXT:    [[BC_MERGE_RDX:%.*]] = phi double [ 0.000000e+00, [[FOR_BODY_PREHEADER]] ], [ [[TMP11]], [[MIDDLE_BLOCK]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]], !dbg [[DBG26]]
; CHECK:       for.cond.cleanup.loopexit:
; CHECK-NEXT:    [[ADD_LCSSA:%.*]] = phi double [ [[ADD:%.*]], [[FOR_BODY]] ], [ [[TMP11]], [[MIDDLE_BLOCK]] ]
; CHECK-NEXT:    br label [[FOR_COND_CLEANUP]], !dbg [[DBG32:![0-9]+]]
; CHECK:       for.cond.cleanup:
; CHECK-NEXT:    [[A_0_LCSSA:%.*]] = phi double [ 0.000000e+00, [[ENTRY:%.*]] ], [ [[ADD_LCSSA]], [[FOR_COND_CLEANUP_LOOPEXIT]] ]
; CHECK-NEXT:    ret double [[A_0_LCSSA]], !dbg [[DBG32]]
; CHECK:       for.body:
; CHECK-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ [[INDVARS_IV_NEXT:%.*]], [[FOR_BODY]] ], [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[A_08:%.*]] = phi double [ [[ADD]], [[FOR_BODY]] ], [ [[BC_MERGE_RDX]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i32, i32* [[V]], i64 [[INDVARS_IV]], !dbg [[DBG26]]
; CHECK-NEXT:    [[TMP12:%.*]] = load i32, i32* [[ARRAYIDX]], align 4, !dbg [[DBG26]], !tbaa [[TBAA14]]
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i32 [[TMP12]], 0, !dbg [[DBG27]]
; CHECK-NEXT:    [[COND:%.*]] = select i1 [[CMP1]], double 3.400000e+00, double 1.150000e+00, !dbg [[DBG26]]
; CHECK-NEXT:    [[ADD]] = fadd double [[A_08]], [[COND]], !dbg [[DBG28]]
; CHECK-NEXT:    [[INDVARS_IV_NEXT]] = add nuw nsw i64 [[INDVARS_IV]], 1, !dbg [[DBG25]]
; CHECK-NEXT:    [[LFTR_WIDEIV:%.*]] = trunc i64 [[INDVARS_IV_NEXT]] to i32, !dbg [[DBG25]]
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i32 [[LFTR_WIDEIV]], [[N]], !dbg [[DBG25]]
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[FOR_COND_CLEANUP_LOOPEXIT]], label [[FOR_BODY]], !dbg [[DBG25]], !prof [[PROF33:![0-9]+]], !llvm.loop [[LOOP34:![0-9]+]]
;
entry:
  %cmp.7 = icmp sgt i32 %n, 0, !dbg !19
  br i1 %cmp.7, label %for.body.preheader, label %for.cond.cleanup, !dbg !21, !prof !30

for.body.preheader:                               ; preds = %entry
  br label %for.body, !dbg !22

for.cond.cleanup.loopexit:                        ; preds = %for.body
  %add.lcssa = phi double [ %add, %for.body ]
  br label %for.cond.cleanup, !dbg !23

for.cond.cleanup:                                 ; preds = %for.cond.cleanup.loopexit, %entry
  %a.0.lcssa = phi double [ 0.000000e+00, %entry ], [ %add.lcssa, %for.cond.cleanup.loopexit ]
  ret double %a.0.lcssa, !dbg !23

for.body:                                         ; preds = %for.body.preheader, %for.body
  %indvars.iv = phi i64 [ %indvars.iv.next, %for.body ], [ 0, %for.body.preheader ]
  %a.08 = phi double [ %add, %for.body ], [ 0.000000e+00, %for.body.preheader ]
  %arrayidx = getelementptr inbounds i32, i32* %v, i64 %indvars.iv, !dbg !22
  %0 = load i32, i32* %arrayidx, align 4, !dbg !22, !tbaa !11
  %cmp1 = icmp eq i32 %0, 0, !dbg !24
  %cond = select i1 %cmp1, double 3.400000e+00, double 1.150000e+00, !dbg !22
  %add = fadd double %a.08, %cond, !dbg !25
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1, !dbg !21
  %lftr.wideiv = trunc i64 %indvars.iv.next to i32, !dbg !21
  %exitcond = icmp eq i32 %lftr.wideiv, %n, !dbg !21
  br i1 %exitcond, label %for.cond.cleanup.loopexit, label %for.body, !dbg !21, !llvm.loop !26, !prof !31
}

attributes #0 = { nounwind }

!llvm.dbg.cu = !{!28}
!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = !{i32 1, !"PIC Level", i32 2}
!2 = !{!"clang version 3.7.0"}
!3 = !DILocation(line: 5, column: 20, scope: !4)
!4 = distinct !DISubprogram(name: "cond_sum", scope: !5, file: !5, line: 1, type: !6, isLocal: false, isDefinition: true, scopeLine: 1, flags: DIFlagPrototyped, isOptimized: true, unit: !28, retainedNodes: !7)
!5 = !DIFile(filename: "no_fpmath.c", directory: "")
!6 = !DISubroutineType(types: !7)
!7 = !{}
!8 = !DILocation(line: 5, column: 3, scope: !4)
!9 = !DILocation(line: 6, column: 14, scope: !4)
!10 = !DILocation(line: 9, column: 3, scope: !4)
!11 = !{!12, !12, i64 0}
!12 = !{!"int", !13, i64 0}
!13 = !{!"omnipotent char", !14, i64 0}
!14 = !{!"Simple C/C++ TBAA"}
!15 = !DILocation(line: 6, column: 19, scope: !4)
!16 = !DILocation(line: 6, column: 11, scope: !4)
!17 = distinct !{!17, !18}
!18 = !{!"llvm.loop.unroll.disable"}
!19 = !DILocation(line: 16, column: 20, scope: !20)
!20 = distinct !DISubprogram(name: "cond_sum_loop_hint", scope: !5, file: !5, line: 12, type: !6, isLocal: false, isDefinition: true, scopeLine: 12, flags: DIFlagPrototyped, isOptimized: true, unit: !28, retainedNodes: !7)
!21 = !DILocation(line: 16, column: 3, scope: !20)
!22 = !DILocation(line: 17, column: 14, scope: !20)
!23 = !DILocation(line: 20, column: 3, scope: !20)
!24 = !DILocation(line: 17, column: 19, scope: !20)
!25 = !DILocation(line: 17, column: 11, scope: !20)
!26 = distinct !{!26, !27, !18}
!27 = !{!"llvm.loop.vectorize.enable", i1 true}
!28 = distinct !DICompileUnit(language: DW_LANG_C99, producer: "clang",
  file: !5,
  isOptimized: true, flags: "-O2",
  splitDebugFilename: "abc.debug", emissionKind: 2)
!29 = !{!"function_entry_count", i64 3}
!30 = !{!"branch_weights", i32 99, i32 1}
!31 = !{!"branch_weights", i32 1, i32 99}
