# Path Highlighting Reference

## Color Map

Each violation category gets a distinct color for visual identification:

| Category | Color Name | RGB | Vivado Color Index | Display Order |
|---|---|---|---|---|
| CDC | Red | `#FF0000` | 1 | 1st |
| SLR Crossing | Blue | `#0000FF` | 3 | 2nd |
| High Fanout | Orange | `#FF8C00` | 6 | 3rd |
| Long Logic | Green | `#00AA00` | 4 | 4th |
| Unclassified | Purple | `#8B008B` | 7 | 5th |

## Interactive Walkthrough — One Category at a Time

Phase 2 presents each category individually, clearing the previous before showing the next.
This lets the user focus on one violation type at a time.

### Per-category procedure (repeat for each category that has failing paths)

#### Clear previous

```tcl
# Clear any existing highlights from the prior category (or from Phase 1 analysis)
catch {unhighlight_objects [get_highlighted_objects]}
catch {unmark_objects [get_marked_objects]}
```

#### Highlight this category's representative path

```tcl
# For a given timing path object $path and color_index $cidx:
highlight_objects -color_index $cidx [get_cells -of_objects $path]
highlight_objects -color_index $cidx [get_nets  -of_objects $path]

# Mark startpoint and endpoint pins for extra visibility
mark_objects -color $color_name [get_pins [get_property STARTPOINT_PIN $path]]
mark_objects -color $color_name [get_pins [get_property ENDPOINT_PIN   $path]]
```

Concrete examples per category:

```tcl
# CDC (Red, index 1)
highlight_objects -color_index 1 [get_cells -of_objects $cdc_path]
highlight_objects -color_index 1 [get_nets  -of_objects $cdc_path]
mark_objects -color red [get_pins [get_property STARTPOINT_PIN $cdc_path]]
mark_objects -color red [get_pins [get_property ENDPOINT_PIN   $cdc_path]]

# SLR Crossing (Blue, index 3)
highlight_objects -color_index 3 [get_cells -of_objects $slr_path]
highlight_objects -color_index 3 [get_nets  -of_objects $slr_path]
mark_objects -color blue [get_pins [get_property STARTPOINT_PIN $slr_path]]
mark_objects -color blue [get_pins [get_property ENDPOINT_PIN   $slr_path]]

# High Fanout (Orange, index 6)
highlight_objects -color_index 6 [get_cells -of_objects $fanout_path]
highlight_objects -color_index 6 [get_nets  -of_objects $fanout_path]
mark_objects -color orange [get_pins [get_property STARTPOINT_PIN $fanout_path]]
mark_objects -color orange [get_pins [get_property ENDPOINT_PIN   $fanout_path]]

# Long Logic (Green, index 4)
highlight_objects -color_index 4 [get_cells -of_objects $logic_path]
highlight_objects -color_index 4 [get_nets  -of_objects $logic_path]
mark_objects -color green [get_pins [get_property STARTPOINT_PIN $logic_path]]
mark_objects -color green [get_pins [get_property ENDPOINT_PIN   $logic_path]]

# Unclassified (Purple/Magenta, index 7)
highlight_objects -color_index 7 [get_cells -of_objects $unclass_path]
highlight_objects -color_index 7 [get_nets  -of_objects $unclass_path]
mark_objects -color magenta [get_pins [get_property STARTPOINT_PIN $unclass_path]]
mark_objects -color magenta [get_pins [get_property ENDPOINT_PIN   $unclass_path]]
```

#### Fit view to highlighted path

```tcl
select_objects [get_cells -of_objects $path]
# Zoom to fit the selected objects
catch {fit_objects [get_highlighted_objects]}
```

#### Report this path's timing

**NOTE:** `report_timing -of_objects` does NOT accept timing path objects (UG835).
Use `-from`/`-to` with the startpoint/endpoint pins extracted from the path object.

```tcl
report_timing \
  -from [get_pins [get_property STARTPOINT_PIN $path]] \
  -to   [get_pins [get_property ENDPOINT_PIN   $path]] \
  -name "<Category>_Representative"
```

#### USER GATE — Wait for user before proceeding to next category

Present the timing report and path details. Then:
- If more categories remain: **"Proceed to next category: \<name\> (\<color\>)?"**
- If last category: **"All categories reviewed. Show all paths highlighted together, or clear marks?"**

## Composite View (Optional — on user request)

After all individual categories have been reviewed, re-highlight all representative paths together with their distinct colors. Do NOT clear between categories this time.

```tcl
# Clear once, then highlight all
catch {unhighlight_objects [get_highlighted_objects]}
catch {unmark_objects [get_marked_objects]}

# Highlight all representative paths (only those that exist)
if {[info exists cdc_path]} {
    highlight_objects -color_index 1 [get_cells -of_objects $cdc_path]
    highlight_objects -color_index 1 [get_nets  -of_objects $cdc_path]
    mark_objects -color red [get_pins [get_property STARTPOINT_PIN $cdc_path]]
    mark_objects -color red [get_pins [get_property ENDPOINT_PIN   $cdc_path]]
}
if {[info exists slr_path]} {
    highlight_objects -color_index 3 [get_cells -of_objects $slr_path]
    highlight_objects -color_index 3 [get_nets  -of_objects $slr_path]
    mark_objects -color blue [get_pins [get_property STARTPOINT_PIN $slr_path]]
    mark_objects -color blue [get_pins [get_property ENDPOINT_PIN   $slr_path]]
}
if {[info exists fanout_path]} {
    highlight_objects -color_index 6 [get_cells -of_objects $fanout_path]
    highlight_objects -color_index 6 [get_nets  -of_objects $fanout_path]
    mark_objects -color orange [get_pins [get_property STARTPOINT_PIN $fanout_path]]
    mark_objects -color orange [get_pins [get_property ENDPOINT_PIN   $fanout_path]]
}
if {[info exists logic_path]} {
    highlight_objects -color_index 4 [get_cells -of_objects $logic_path]
    highlight_objects -color_index 4 [get_nets  -of_objects $logic_path]
    mark_objects -color green [get_pins [get_property STARTPOINT_PIN $logic_path]]
    mark_objects -color green [get_pins [get_property ENDPOINT_PIN   $logic_path]]
}

# Fit all
catch {fit_objects [get_highlighted_objects]}
```

## Cleanup

When the user is done reviewing, clear all marks:

```tcl
unhighlight_objects [get_highlighted_objects]
unmark_objects [get_marked_objects]
```

<p class="sphinxhide" align="center"><sub>Copyright © 2026 Advanced Micro Devices, Inc</sub></p>
<p class="sphinxhide" align="center"><sup><a href="https://www.amd.com/en/corporate/copyright">Terms and Conditions</a></sup></p>
