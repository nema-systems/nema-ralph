# Safety Release Assessment Plan

## Phase 0: Intake & Planning
- [ ] [VALIDATE] Validate intake — read intake.yaml, verify required fields, write results/00-intake-summary.md
- [ ] [PLAN] Generate tailored analysis plan — replace placeholder phases below with concrete tasks scoped to this system's architecture, standards, and risk appetite

## Phase 1: Architecture
- [ ] [ANALYZE] Architecture survey — map all processes/daemons/components, IPC/messaging, safety-critical data paths, hardware boundaries, tech stack → results/01-architecture.md
- [ ] [JUDGE] Evaluate architecture survey
- [ ] [DIAGRAM] Architecture diagram — build Mermaid flowchart from survey; mark each element verified or inferred; annotate safety boundary and actuation chain → results/02-architecture-diagram.md
- [ ] [JUDGE] Evaluate architecture diagram

## Phase 2: Hazard Analysis (HARA)
- [ ] [ANALYZE] HARA — derive hazardous events from ODD scenarios; apply S×E×C per ISO 26262 Annex B; assign ASIL to each event; derive functional safety goals; cross-check against any existing HARA in existing-docs/ → results/03-hara.md
- [ ] [JUDGE] Evaluate HARA

## Phase 3: Safety Requirements
- [ ] [ANALYZE] Safety requirements — from each safety goal derive FSRs; from FSRs derive TSRs; trace each TSR to specific code locations; explicitly flag safety goals with no implementation and TSRs where code does not meet the requirement → results/04-safety-requirements.md
- [ ] [JUDGE] Evaluate safety requirements

## Phase 4: Interface Safety Analysis
- [ ] [ANALYZE] Interface safety — for each safety-critical data path: define producer contract, consumer assumptions, failure modes at boundary (stale/corrupt/out-of-range/missing), existing guards, gaps → results/05-interface-safety.md
- [ ] [JUDGE] Evaluate interface safety analysis

## Phase 5: Subsystem Safety Analysis
<!-- [PLAN] replaces these placeholders with one analyze+judge pair per safety-critical subsystem -->
- [ ] [ANALYZE] Safety analysis: {subsystem_1} → results/06-safety-{name}.md
- [ ] [JUDGE] Evaluate {subsystem_1} safety analysis
- [ ] [ANALYZE] Safety analysis: {subsystem_2} → results/07-safety-{name}.md
- [ ] [JUDGE] Evaluate {subsystem_2} safety analysis

## Phase 6: Failure Mode Analysis
<!-- FMEAs scoped to subsystems with ASIL-B or above from HARA -->
- [ ] [ANALYZE] FMEA: {subsystem_1} — failure modes, effects, severity/occurrence/detection, RPN; trace failure paths to actuator or human hazard → results/08-fmea-{name}.md
- [ ] [JUDGE] Evaluate {subsystem_1} FMEA
- [ ] [ANALYZE] FMEA: {subsystem_2} → results/09-fmea-{name}.md
- [ ] [JUDGE] Evaluate {subsystem_2} FMEA

## Phase 7: Dependencies
<!-- [PLAN] adds one analyze+judge per safety-critical dependency (ancillary repos, hardware safety components, ML inference engines) -->
- [ ] [ANALYZE] Dependency analysis: {dependency_1} → results/10-dep-{name}.md
- [ ] [JUDGE] Evaluate {dependency_1} analysis

## Phase 8: ML Behavioral Evidence
<!-- Include only if system has ML/neural net components -->
- [ ] [ANALYZE] ML behavioral evidence survey — identify all model components; crawl for simulation configs, benchmark results, eval logs; map scenario coverage against ODD dimensions from intake.yaml; assess gaps → results/11-ml-evidence.md
- [ ] [JUDGE] Evaluate ML behavioral evidence

## Phase 9: Verification Assessment
- [ ] [ANALYZE] Test coverage — map all test files to safety-critical code; distinguish unit/integration/system/fault-injection tests; identify missing coverage for each ASIL-B+ subsystem → results/12-test-coverage.md
- [ ] [JUDGE] Evaluate test coverage

## Phase 10: Compliance Assessment
<!-- [PLAN] adds one analyze+judge pair per required standard from intake.yaml -->
- [ ] [ANALYZE] {Standard} gap analysis — clauses vs. evidence; distinguish evidence gaps from compliance gaps; actionable remediation per gap → results/13-{standard}-gaps.md
- [ ] [JUDGE] Evaluate {standard} gap analysis

## Phase 11: Deep Dive
- [ ] [ANALYZE] Deep dive — verify and trace root causes of highest-severity findings from all preceding phases; confirm mitigations are real; cross-check each finding against the architecture diagram to verify the failure path is consistent with the actual system structure → results/14-deep-dive.md
- [ ] [JUDGE] Evaluate deep dive

## Phase 12: Synthesis
- [ ] [ANALYZE] Final report — aggregate all findings; rank risks by severity; map risks to safety goals from HARA; include explicit Limitations section (what was not analyzed, cross-subsystem failure chains, known scope gaps); format per intake risk_appetite (explore/audit/ship) → results/final-report.md
- [ ] [JUDGE] Evaluate final report

## Phase 13: Refinement
- [ ] [REFINE] Cross-reference all documents — resolve inconsistencies, update architecture diagram with any findings missed in Phase 1 → results/refinement-log.md
- [ ] [CONVERGE] Assess convergence — CONVERGED if <3 actionable inconsistencies remain; otherwise add targeted [REFINE] items
- [ ] [JUDGE] Evaluate refinement

## Completed
- [ ] Project initialized

## Notes
- FMEA scope is derived from HARA ASIL ratings — every ASIL-B+ subsystem gets an FMEA
- [PLAN] replaces placeholder items in Phases 5-10 with concrete tasks based on architecture + intake
- Judge corrections: P0 = factual error (applied inline); P1 = shallow analysis (injected as new task); P2 = framing
- Limitations section in final report must explicitly name what was not analyzed
