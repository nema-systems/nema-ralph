#!/usr/bin/env bash
# safety-intake.sh — Prompts for system context and writes intake.yaml
# Sourced by ralph_enable.sh when --template safety is used.
# Assumes wizard_utils.sh is already sourced (prompt_text, print_* available).

INTAKE_FILE="intake.yaml"

if [[ -f "$INTAKE_FILE" ]]; then
    print_success "intake.yaml already exists — skipping intake questions"
    return 0
fi

if [[ "$NON_INTERACTIVE" == "true" ]]; then
    cat > "$INTAKE_FILE" << 'EOF'
# intake.yaml — Fill in all fields before running: ralph --monitor

system:
  description: "FILL IN: what this system does"
  actuation: "FILL IN: what it actuates (e.g. steering, braking, throttle, or none)"
  automation_level: "FILL IN: SAE level or plain description (e.g. L2, L3, conditional automation)"

operational_design_domain:
  road_types: "FILL IN: road types in scope (e.g. highway, urban, suburban, rural)"
  speed_max_kph: 0  # FILL IN
  driver_in_loop: "FILL IN: yes or no"
  geography: "FILL IN: regions in scope (e.g. North America, EU, global)"
  weather: "FILL IN: weather conditions in scope (e.g. all weather, clear only)"

regulatory:
  required_standards: "FILL IN: applicable standards (e.g. ISO 26262, SOTIF, ISO 21434, MISRA C) or unknown"
  jurisdiction: "FILL IN: regulatory jurisdiction (e.g. UNECE, NHTSA, EU, or none)"

hardware:
  independent_safety_hw: "FILL IN: yes or no"
  safety_hw_description: "FILL IN: describe safety hardware if present (e.g. dedicated watchdog MCU)"

risk_appetite:
  goal: "FILL IN: ship, audit, or explore"
  # ship    = identify release blockers and required waivers
  # audit   = full clause-by-clause compliance gap analysis
  # explore = open-ended risk discovery, no release decision required

existing_work:
  hara: "FILL IN: path to existing HARA document, or none"
  safety_plan: "FILL IN: path to existing safety plan, or none"
  notes: ""
EOF
    print_success "intake.yaml created with placeholders — fill in before running ralph --monitor"
    return 0
fi

echo "  Answer questions about the system being analyzed."
echo "  Press Enter to leave a field blank (you can edit intake.yaml afterwards)."
echo ""

system_description=$(prompt_text "System description — what does this system do?")
system_actuation=$(prompt_text "What does it actuate? (e.g. steering, braking, throttle, or none)")
automation_level=$(prompt_text "Automation level (e.g. SAE L2, L3, or plain description)")

echo ""
system_road_types=$(prompt_text "ODD road types (e.g. highway, urban, suburban, rural)")
system_speed_max=$(prompt_text "ODD max speed (kph)" "0")
system_driver_in_loop=$(prompt_text "Driver in loop? (yes / no)")
system_geography=$(prompt_text "ODD geography (e.g. North America, EU, global)")
system_weather=$(prompt_text "ODD weather conditions (e.g. all weather, clear only)")

echo ""
required_standards=$(prompt_text "Required standards (e.g. ISO 26262, SOTIF, ISO 21434, MISRA C, or unknown)")
jurisdiction=$(prompt_text "Regulatory jurisdiction (e.g. UNECE, NHTSA, EU, or none)")

echo ""
indep_safety_hw=$(prompt_text "Independent safety hardware present? (yes / no)")
safety_hw_desc=$(prompt_text "Safety hardware description (if yes — e.g. dedicated watchdog MCU)")

echo ""
risk_goal=$(prompt_text "Risk appetite goal (ship / audit / explore)" "explore")

echo ""
existing_hara=$(prompt_text "Path to existing HARA document, or none" "none")
existing_safety_plan=$(prompt_text "Path to existing safety plan, or none" "none")

cat > "$INTAKE_FILE" << EOF
system:
  description: "${system_description}"
  actuation: "${system_actuation}"
  automation_level: "${automation_level}"

operational_design_domain:
  road_types: "${system_road_types}"
  speed_max_kph: ${system_speed_max}
  driver_in_loop: "${system_driver_in_loop}"
  geography: "${system_geography}"
  weather: "${system_weather}"

regulatory:
  required_standards: "${required_standards}"
  jurisdiction: "${jurisdiction}"

hardware:
  independent_safety_hw: "${indep_safety_hw}"
  safety_hw_description: "${safety_hw_desc}"

risk_appetite:
  goal: "${risk_goal}"
  # ship    = identify release blockers and required waivers
  # audit   = full clause-by-clause compliance gap analysis
  # explore = open-ended risk discovery, no release decision required

existing_work:
  hara: "${existing_hara}"
  safety_plan: "${existing_safety_plan}"
  notes: ""
EOF

print_success "intake.yaml written"
