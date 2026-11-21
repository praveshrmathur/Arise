# PROJECT HUNTER
> **YOUR REAL LIFE. YOUR MISSIONS. YOUR PROGRESSION.**

PROJECT HUNTER is a cross-platform fitness RPG application for Android and iOS that transforms real-world fitness, exercise, healthy habits, and personal discipline into an immersive progression system.

Inspired by the atmosphere and progression mechanics of *Solo Leveling*, but built with **100% original branding, terminology, UI architecture, and artwork**.

---

## 1. Product Architecture

```
lib/
├── main.dart                          # Application Entry point & ProviderScope
├── app/
│   ├── app.dart                       # MaterialApp.router configuration
│   ├── router.dart                    # GoRouter navigation & ShellRoute
│   └── theme/
│       ├── hunter_colors.dart         # Design Tokens: Background #080B12, Cyan #00E5FF, Electric Blue #39A9FF
│       ├── hunter_typography.dart     # Space Grotesk (Display) & Inter (Body)
│       ├── hunter_shadows.dart        # Neon holographic glow and card shadows
│       └── hunter_theme.dart          # Material 3 Custom Dark Theme
├── core/
│   ├── constants/
│   │   ├── app_constants.dart         # App identity & storage keys
│   │   └── rank_constants.dart        # Ranks E, D, C, B, A, S milestones & colors
│   ├── errors/
│   │   └── failures.dart              # Failure & exception classes
│   ├── services/
│   │   └── supabase_service.dart      # Supabase client initializer & config
│   ├── utils/
│   │   ├── level_calculator.dart      # Progression Engine: XP required = 100 + (50 * currentLevel)
│   │   └── date_formatter.dart        # Time, duration, and date formatting
│   └── widgets/
│       ├── holographic_card.dart      # Futuristic RPG illuminated border container
│       ├── hunter_app_bar.dart        # Standardized System status bar
│       ├── hunter_bottom_nav.dart     # Custom 5-destination illuminated navigation bar
│       ├── hunter_button.dart         # Electric gradient & holographic outline buttons
│       ├── hunter_progress_bar.dart   # Animated neon progression bar
│       ├── rank_badge.dart            # Glowing rank letter emblem
│       ├── attribute_hexagon.dart     # STR, AGI, VIT, END, DIS attribute cards
│       └── system_toast.dart          # In-app holographic alert overlay
├── features/
│   ├── auth/                          # Splash, Welcome, Login, Register
│   ├── onboarding/                    # Hunter calibration (Identity, Experience, Gear, Limitations)
│   ├── dashboard/                     # Home terminal: Stats, level, XP bar, daily summary, quick actions
│   ├── quests/                        # Daily missions, categories, manual confirmation, skip with no penalty
│   ├── hunter_status/                 # Detailed Character status sheet, attributes, XP audit ledger
│   ├── training/                      # Exercise Codex, pre-built protocols, active workout logger & rest timer
│   ├── profile/                       # Hardware sync, subscription tier, operator commands
│   ├── health/                        # Health Connect & Apple HealthKit integration services
│   └── ai_coach/                      # Gemini AI daily quest generation with safety validation
└── shared/
    ├── models/
    │   ├── xp_transaction_model.dart  # Immutable transaction records
    │   └── achievement_model.dart     # Hunter achievements
    └── repositories/
```

---

## 2. Visual Design Tokens

| Property | Value | Description |
| :--- | :--- | :--- |
| **Background** | `#080B12` | Deep cinematic void canvas |
| **Primary Surface** | `#101725` | Futuristic holographic console panel |
| **Secondary Surface**| `#172235` | Secondary card & table containers |
| **Electric Blue** | `#39A9FF` | Primary energy accent & XP bar |
| **Cyan** | `#00E5FF` | Active illuminated borders & buttons |
| **Success** | `#36D399` | Cleared quest confirmation |
| **Warning** | `#FFB547` | Active streak indicators |

---

## 3. Progression & Level Formula

The Level Progression Engine calculates required XP using the deterministic formula:
$$\text{XP Required for Next Level} = 100 + (50 \times \text{Current Level})$$

### Hunter Ranks:
- **E** — Rookie (Level 1–9)
- **D** — Apprentice (Level 10–24)
- **C** — Skilled (Level 25–49)
- **B** — Elite (Level 50–79)
- **A** — Master (Level 80–99)
- **S** — Legendary (Level 100+)

### Character Attributes:
- **STR (Strength)**: Progressive overload, push-ups, barbell/dumbbell resistance training.
- **AGI (Agility)**: Movement, walking steps, cadence, running.
- **VIT (Vitality)**: Recovery, sleep, hydration, mobility decompression.
- **END (Endurance)**: Aerobic capacity, cardiovascular sessions.
- **DIS (Discipline)**: Consecutive habit streaks, daily completions.

---

## 4. Supabase Database & Security

Located in `supabase/migrations/20261121000001_project_hunter_schema.sql`:
- 15 relational tables with UUID keys and foreign key constraints.
- Row Level Security (RLS) enabled on all tables.
- Clients cannot directly overwrite XP transactions or rank progressions.
- Server-side atomic stored procedure `public.award_hunter_xp()` handles transactions safely.

---

## 5. Running the Application

### Prerequisites:
1. Flutter SDK (>=3.16.0) installed and added to `PATH`.
2. Android Studio / Xcode for emulator or physical device testing.

### Commands:
```bash
# 1. Fetch dependencies
flutter pub get

# 2. Run static analysis
flutter analyze

# 3. Run unit and widget test suite
flutter test

# 4. Launch on connected device or emulator (offline/demo mode by default)
flutter run

# 5. Launch with live Supabase credentials
flutter run \
  --dart-define=SUPABASE_URL=https://<your-project>.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=<your-anon-key>
```
