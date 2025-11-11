# Visual Style Guide

## Overview

This style guide defines the visual language of RehabTracker Pro. It ensures consistency across all screens and components while maintaining a professional, healthcare-appropriate aesthetic.

## Color Palette

### Light Mode

#### Primary Colors
- **Primary**: `#0061A4` - Deep professional blue
  - Use for: Primary actions, key UI elements, active states
- **Primary Container**: `#D1E4FF` - Light blue
  - Use for: Subtle backgrounds, selected states
- **On Primary**: `#FFFFFF` - White
  - Use for: Text on primary color backgrounds

#### Secondary Colors
- **Secondary**: `#535F70` - Refined gray-blue
  - Use for: Secondary actions, supporting UI elements
- **Secondary Container**: `#D7E3F7` - Light gray-blue
  - Use for: Secondary backgrounds
- **On Secondary**: `#FFFFFF` - White
  - Use for: Text on secondary color backgrounds

#### Tertiary Colors
- **Tertiary**: `#6B5778` - Subtle purple accent
  - Use for: Accent elements, special highlights
- **Tertiary Container**: `#F2DAFF` - Light purple
  - Use for: Accent backgrounds

#### Surface Colors
- **Surface**: `#FDFCFF` - Clean white
  - Use for: Card backgrounds, elevated surfaces
- **Background**: `#FDFCFF` - Clean white
  - Use for: Screen backgrounds
- **On Surface**: `#1A1C1E` - Dark gray
  - Use for: Primary text on surfaces

#### Semantic Colors
- **Error**: `#BA1A1A` - Red
  - Use for: Error states, destructive actions
- **Success**: `#00C853` - Green
  - Use for: Success states, positive feedback
- **Warning**: `#FFA726` - Orange
  - Use for: Warning states, caution indicators

### Dark Mode

#### Primary Colors
- **Primary**: `#9ECAFF` - Light blue
- **Primary Container**: `#00497D` - Dark blue
- **On Primary**: `#003258` - Deep blue

#### Secondary Colors
- **Secondary**: `#BBC7DB` - Light gray-blue
- **Secondary Container**: `#3B4858` - Dark gray-blue
- **On Secondary**: `#253140` - Deep gray-blue

#### Tertiary Colors
- **Tertiary**: `#DDBCE0` - Light purple
- **Tertiary Container**: `#523F5F` - Dark purple

#### Surface Colors
- **Surface**: `#1A1C1E` - Dark gray
- **Background**: `#1A1C1E` - Dark gray
- **On Surface**: `#E2E2E6` - Light gray

#### Semantic Colors
- **Error**: `#FFB4AB` - Light red
- **Success**: `#69F0AE` - Light green
- **Warning**: `#FFD54F` - Light orange

## Typography

### Font Family
- **Primary**: System default (San Francisco on iOS, Roboto on Android)
- **Fallback**: Default sans-serif

### Type Scale

#### Display
- **Display Large**: 57px / 400 weight / -0.25 letter spacing
  - Use for: Hero numbers, key statistics (e.g., recovery points)
- **Display Medium**: 45px / 400 weight / 0 letter spacing
  - Use for: Large headings
- **Display Small**: 36px / 400 weight / 0 letter spacing
  - Use for: Section headings

#### Headline
- **Headline Large**: 32px / 600 weight / 0 letter spacing
  - Use for: Major section titles
- **Headline Medium**: 28px / 600 weight / 0 letter spacing
  - Use for: Subsection titles
- **Headline Small**: 24px / 600 weight / 0 letter spacing
  - Use for: Card titles, dialog titles

#### Title
- **Title Large**: 22px / 500 weight / 0 letter spacing
  - Use for: List headers, prominent labels
- **Title Medium**: 16px / 500 weight / 0.15 letter spacing
  - Use for: List item titles
- **Title Small**: 14px / 500 weight / 0.1 letter spacing
  - Use for: Dense list items

#### Body
- **Body Large**: 16px / 400 weight / 0.5 letter spacing
  - Use for: Primary body text
- **Body Medium**: 14px / 400 weight / 0.25 letter spacing
  - Use for: Secondary body text

#### Label
- **Label Large**: 14px / 500 weight / 0.1 letter spacing
  - Use for: Button labels, form labels
- **Label Medium**: 12px / 500 weight / 0.5 letter spacing
  - Use for: Small labels, captions
- **Label Small**: 11px / 500 weight / 0.5 letter spacing
  - Use for: Tiny labels, legal text

### Line Heights
- **Display**: 1.2
- **Headline**: 1.3
- **Title**: 1.4
- **Body**: 1.5-1.6 (optimal for readability)
- **Label**: 1.4

## Spacing System

### Grid
All spacing follows an 8px grid system.

### Spacing Scale
- **xs**: 8px - Tight spacing between related elements
- **sm**: 16px - Compact spacing within components
- **md**: 24px - Standard spacing between sections
- **lg**: 32px - Generous spacing, screen edges
- **xl**: 48px - Extra generous spacing for major sections

### Common Patterns
- **Screen padding**: 32px (lg) on edges
- **Section spacing**: 24px (md) between sections
- **Component spacing**: 16px (sm) within components
- **Element spacing**: 8px (xs) between related elements
- **List item spacing**: 24px (md) between items

## Elevation

### Levels
- **Level 0**: 0dp - Flat surfaces, no shadow
- **Level 1**: 1dp - Subtle elevation for cards
- **Level 2**: 3dp - Floating action buttons
- **Level 3**: 6dp - Dialogs, modals
- **Level 4**: 8dp - Navigation drawer
- **Level 5**: 12dp - Modal bottom sheets

### Usage Guidelines
- Use minimal elevation for a clean, modern look
- Prefer Level 0 or Level 1 for most surfaces
- Reserve higher levels for truly elevated content
- Use subtle shadows (low opacity, small blur)

## Border Radius

### Scale
- **Small**: 8px - Buttons, chips, small cards
- **Medium**: 12px - Cards, dialogs
- **Large**: 16px - Large cards, bottom sheets
- **Extra Large**: 24px - Hero elements

### Usage
- Use consistent radius throughout the app
- Prefer 12px for most cards and containers
- Use 8px for buttons and small elements
- Avoid mixing different radii in the same component

## Iconography

### Size Scale
- **Small**: 16px - Inline icons, dense lists
- **Medium**: 24px - Standard icons
- **Large**: 28px - Navigation icons
- **Extra Large**: 32px - Feature icons, empty states
- **Hero**: 48-64px - Large empty states, onboarding

### Style
- Use Material Icons (outlined variant preferred)
- Maintain consistent stroke weight
- Use filled icons for active/selected states
- Use outlined icons for inactive states

### Color
- Use theme colors for icons
- Primary color for active/important icons
- On-surface variant for secondary icons
- Semantic colors for status icons (error, success, warning)

## Layout Patterns

### Open Layout (Preferred)
- Minimize card usage
- Use generous whitespace
- Rely on subtle dividers (1px, 10% opacity)
- Let content breathe

### Card Layout (When Needed)
- Use Level 1 elevation (subtle)
- 12px border radius
- 24px internal padding
- Use sparingly

### List Layout
- 88px minimum item height (for accessibility)
- 24px spacing between items
- Subtle dividers (1px, 10% opacity)
- Clear visual hierarchy

## Component Specifications

### Buttons

#### Primary (Filled)
- Height: 64-72px
- Padding: 24px horizontal
- Font: Label Large (14px, 500 weight)
- Border radius: 8px
- Background: Primary color
- Text: On Primary color

#### Secondary (Outlined)
- Height: 64-72px
- Padding: 24px horizontal
- Font: Label Large (14px, 500 weight)
- Border: 2px, Primary color
- Border radius: 8px
- Background: Transparent
- Text: Primary color

#### Tertiary (Text)
- Height: 48px
- Padding: 16px horizontal
- Font: Label Large (14px, 500 weight)
- Background: Transparent
- Text: Primary color

### Text Fields
- Height: 64px
- Font: Body Large (16px)
- Label: Body Medium (14px)
- Border: 1px outlined
- Border radius: 8px
- Padding: 16px

### Checkboxes
- Size: 32x32px
- Border: 2px
- Border radius: 4px
- Check mark: Bold, clear

### Switches
- Width: 52px
- Height: 32px
- Thumb: 28px diameter
- Track: 8px height

### Sliders
- Track height: 8px
- Thumb size: 28px diameter
- Active track: Primary color
- Inactive track: Surface variant

### Navigation Bar
- Height: 88px
- Icon size: 28px
- Label: Label Large (14px)
- Active indicator: Subtle background
- Padding: 8px

## Animation

### Duration
- **Instant**: 0ms - No animation
- **Quick**: 100ms - Micro-interactions (hover, press)
- **Standard**: 200-300ms - Most transitions
- **Slow**: 300-500ms - Complex animations
- **Very Slow**: 500-800ms - Page transitions

### Curves
- **Smooth Transition**: `easeInOutCubicEmphasized` - Most transitions
- **Particle Float**: `easeOutQuart` - Floating animations
- **Pulse**: `easeInOutQuad` - Attention-grabbing
- **Elastic**: `elasticOut` - Playful entrances (use sparingly)

### Principles
- Respect reduced motion preferences
- Use smooth, professional curves
- Keep animations subtle and purposeful
- Avoid distracting or excessive animation

## Accessibility

### Contrast Ratios
- **Normal text**: Minimum 4.5:1 (WCAG AA)
- **Large text**: Minimum 3:1 (WCAG AA)
- **UI components**: Minimum 3:1 (WCAG AA)
- **Target**: 7:1 (WCAG AAA) where possible

### Touch Targets
- **Minimum**: 48x48dp (WCAG AA)
- **Preferred**: 56x56dp
- **Spacing**: 8dp minimum between targets

### Focus Indicators
- **Width**: 2px
- **Color**: Primary color
- **Offset**: 2px from element
- **Style**: Solid outline

## Best Practices

### Do's
✓ Use theme colors consistently
✓ Follow the 8px grid system
✓ Maintain clear typography hierarchy
✓ Use generous whitespace
✓ Ensure large touch targets (56x56dp)
✓ Test in both light and dark modes
✓ Verify accessibility (contrast, screen readers)
✓ Use smooth, subtle animations
✓ Minimize card usage
✓ Keep layouts open and breathable

### Don'ts
✗ Don't use hardcoded colors
✗ Don't ignore the spacing system
✗ Don't use small fonts (<14px for body text)
✗ Don't create small touch targets (<48x48dp)
✗ Don't use excessive elevation
✗ Don't overuse cards and containers
✗ Don't create cluttered layouts
✗ Don't use distracting animations
✗ Don't ignore accessibility
✗ Don't mix different design patterns

## Examples

### Dashboard Card (Minimal)
```
┌─────────────────────────────────────┐
│                                     │
│  Recovery Points                    │  ← Title Large (22px)
│  150                                │  ← Display Large (57px)
│                                     │
│  Level 3 • Intermediate             │  ← Body Medium (14px)
│                                     │
└─────────────────────────────────────┘
  ↑ 32px padding, no card, subtle background
```

### Button Group
```
┌──────────────┐  ┌──────────────┐
│  Start Now   │  │   Cancel     │
└──────────────┘  └──────────────┘
  ↑ Primary        ↑ Secondary
  64px height      64px height
  24px padding     24px padding
```

### List Item
```
┌─────────────────────────────────────┐
│  ☐  Morning Stretches               │  ← 88px height
│     10 minutes • 5 points           │  ← 32px checkbox
│                                     │  ← 20px title
└─────────────────────────────────────┘  ← 14px subtitle
  ↑ 24px spacing to next item
```

## Version History

- **v1.0** (Current): Professional Material Design 3 theme
  - Replaced geometric shapes with standard components
  - Implemented open, breathable layouts
  - Enhanced accessibility with large touch targets
  - Refined typography and spacing
