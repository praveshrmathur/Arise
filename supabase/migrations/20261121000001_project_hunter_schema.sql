-- ====================================================================
-- PROJECT HUNTER — CORE DATABASE SCHEMA MIGRATION
-- Production PostgreSQL with Row Level Security (RLS) & Triggers
-- ====================================================================

-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- --------------------------------------------------------------------
-- 1. PROFILES TABLE
-- --------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    hunter_name VARCHAR(60) NOT NULL,
    avatar_url TEXT,
    age_range VARCHAR(20),
    fitness_experience VARCHAR(30) DEFAULT 'beginner',
    fitness_goals TEXT[] DEFAULT '{}',
    activity_level VARCHAR(30) DEFAULT 'moderate',
    training_location VARCHAR(30) DEFAULT 'both',
    available_equipment TEXT[] DEFAULT '{}',
    workout_days_per_week INT DEFAULT 4 CHECK (workout_days_per_week BETWEEN 1 AND 7),
    daily_time_minutes INT DEFAULT 30 CHECK (daily_time_minutes BETWEEN 10 AND 180),
    limitations_notes TEXT,
    has_completed_onboarding BOOLEAN DEFAULT false,
    subscription_tier VARCHAR(20) DEFAULT 'free',
    created_at TIMESTAMPTZ DEFAULT TIMEZONE('utc', NOW()) NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT TIMEZONE('utc', NOW()) NOT NULL
);

-- --------------------------------------------------------------------
-- 2. HUNTER_STATS TABLE
-- --------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.hunter_stats (
    user_id UUID PRIMARY KEY REFERENCES public.profiles(id) ON DELETE CASCADE,
    level INT DEFAULT 1 CHECK (level >= 1) NOT NULL,
    rank VARCHAR(10) DEFAULT 'E' NOT NULL,
    total_xp INT DEFAULT 0 CHECK (total_xp >= 0) NOT NULL,
    strength INT DEFAULT 10 CHECK (strength >= 1) NOT NULL,
    agility INT DEFAULT 10 CHECK (agility >= 1) NOT NULL,
    vitality INT DEFAULT 10 CHECK (vitality >= 1) NOT NULL,
    endurance INT DEFAULT 10 CHECK (endurance >= 1) NOT NULL,
    discipline INT DEFAULT 10 CHECK (discipline >= 1) NOT NULL,
    current_streak INT DEFAULT 0 CHECK (current_streak >= 0) NOT NULL,
    longest_streak INT DEFAULT 0 CHECK (longest_streak >= 0) NOT NULL,
    total_quests_completed INT DEFAULT 0 CHECK (total_quests_completed >= 0) NOT NULL,
    total_workouts_completed INT DEFAULT 0 CHECK (total_workouts_completed >= 0) NOT NULL,
    last_active_date DATE DEFAULT CURRENT_DATE,
    created_at TIMESTAMPTZ DEFAULT TIMEZONE('utc', NOW()) NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT TIMEZONE('utc', NOW()) NOT NULL
);

-- --------------------------------------------------------------------
-- 3. EXERCISES TABLE (Master Codex)
-- --------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.exercises (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) UNIQUE NOT NULL,
    category VARCHAR(50) NOT NULL, -- bodyweight, dumbbell, barbell, machine, cardio, mobility
    primary_muscle VARCHAR(50) NOT NULL,
    secondary_muscles TEXT[] DEFAULT '{}',
    equipment VARCHAR(50) NOT NULL,
    instructions TEXT NOT NULL,
    difficulty VARCHAR(30) DEFAULT 'beginner',
    created_at TIMESTAMPTZ DEFAULT TIMEZONE('utc', NOW()) NOT NULL
);

-- --------------------------------------------------------------------
-- 4. QUESTS TABLE
-- --------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.quests (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
    title VARCHAR(120) NOT NULL,
    description TEXT NOT NULL,
    category VARCHAR(40) NOT NULL, -- strength, cardio, walking, mobility, recovery, hydration, consistency, discipline
    difficulty VARCHAR(20) DEFAULT 'beginner' NOT NULL,
    instructions TEXT NOT NULL,
    target_metric VARCHAR(40) NOT NULL, -- reps, steps, seconds, ml, minutes
    target_value INT NOT NULL CHECK (target_value > 0),
    unit VARCHAR(20) NOT NULL,
    duration_minutes INT NOT NULL CHECK (duration_minutes > 0),
    xp_reward INT NOT NULL CHECK (xp_reward > 0),
    verification_method VARCHAR(40) DEFAULT 'manual' NOT NULL,
    scheduled_date DATE NOT NULL,
    expires_at TIMESTAMPTZ,
    status VARCHAR(20) DEFAULT 'pending' NOT NULL, -- pending, completed, skipped
    completed_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT TIMEZONE('utc', NOW()) NOT NULL
);

-- --------------------------------------------------------------------
-- 5. QUEST_COMPLETIONS TABLE (Audit log preventing double-dipping)
-- --------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.quest_completions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    quest_id UUID REFERENCES public.quests(id) ON DELETE CASCADE NOT NULL,
    user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
    xp_awarded INT NOT NULL CHECK (xp_awarded > 0),
    verification_payload JSONB DEFAULT '{}',
    completed_at TIMESTAMPTZ DEFAULT TIMEZONE('utc', NOW()) NOT NULL,
    CONSTRAINT unique_user_quest_completion UNIQUE(user_id, quest_id)
);

-- --------------------------------------------------------------------
-- 6. XP_TRANSACTIONS TABLE (Immutable Audit Ledger)
-- --------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.xp_transactions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
    amount INT NOT NULL CHECK (amount > 0),
    reason TEXT NOT NULL,
    source_category VARCHAR(50) NOT NULL,
    reference_id UUID,
    created_at TIMESTAMPTZ DEFAULT TIMEZONE('utc', NOW()) NOT NULL
);

-- --------------------------------------------------------------------
-- 7. WORKOUTS TABLE
-- --------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.workouts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
    title VARCHAR(100) NOT NULL,
    started_at TIMESTAMPTZ NOT NULL,
    ended_at TIMESTAMPTZ,
    duration_seconds INT DEFAULT 0 CHECK (duration_seconds >= 0),
    total_volume_kg NUMERIC(10,2) DEFAULT 0.0 CHECK (total_volume_kg >= 0),
    xp_earned INT DEFAULT 100 CHECK (xp_earned >= 0),
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT TIMEZONE('utc', NOW()) NOT NULL
);

-- --------------------------------------------------------------------
-- 8. WORKOUT_SETS TABLE
-- --------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.workout_sets (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    workout_id UUID REFERENCES public.workouts(id) ON DELETE CASCADE NOT NULL,
    exercise_id UUID REFERENCES public.exercises(id) ON DELETE RESTRICT NOT NULL,
    set_number INT NOT NULL CHECK (set_number > 0),
    repetitions INT NOT NULL CHECK (repetitions >= 0),
    weight_kg NUMERIC(6,2) DEFAULT 0.0 CHECK (weight_kg >= 0),
    is_completed BOOLEAN DEFAULT false NOT NULL,
    created_at TIMESTAMPTZ DEFAULT TIMEZONE('utc', NOW()) NOT NULL
);

-- --------------------------------------------------------------------
-- 9. HEALTH_DAILY_SUMMARIES TABLE
-- --------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.health_daily_summaries (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
    date DATE NOT NULL,
    steps INT DEFAULT 0 CHECK (steps >= 0),
    distance_meters NUMERIC(10,2) DEFAULT 0 CHECK (distance_meters >= 0),
    active_energy_kcal NUMERIC(8,2) DEFAULT 0 CHECK (active_energy_kcal >= 0),
    active_minutes INT DEFAULT 0 CHECK (active_minutes >= 0),
    synced_at TIMESTAMPTZ DEFAULT TIMEZONE('utc', NOW()) NOT NULL,
    CONSTRAINT unique_user_daily_health UNIQUE(user_id, date)
);

-- --------------------------------------------------------------------
-- 10. ACHIEVEMENTS & USER_ACHIEVEMENTS
-- --------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.achievements (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    code VARCHAR(50) UNIQUE NOT NULL,
    title VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    icon_name VARCHAR(50) DEFAULT 'trophy' NOT NULL,
    xp_reward INT DEFAULT 50 NOT NULL,
    created_at TIMESTAMPTZ DEFAULT TIMEZONE('utc', NOW()) NOT NULL
);

CREATE TABLE IF NOT EXISTS public.user_achievements (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
    achievement_id UUID REFERENCES public.achievements(id) ON DELETE CASCADE NOT NULL,
    unlocked_at TIMESTAMPTZ DEFAULT TIMEZONE('utc', NOW()) NOT NULL,
    CONSTRAINT unique_user_achievement UNIQUE(user_id, achievement_id)
);

-- --------------------------------------------------------------------
-- 11. CHALLENGES & USER_CHALLENGES
-- --------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.challenges (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title VARCHAR(120) NOT NULL,
    description TEXT NOT NULL,
    target_metric VARCHAR(50) NOT NULL,
    target_value INT NOT NULL,
    duration_days INT DEFAULT 7 NOT NULL,
    xp_reward INT DEFAULT 150 NOT NULL,
    starts_at TIMESTAMPTZ NOT NULL,
    ends_at TIMESTAMPTZ NOT NULL
);

CREATE TABLE IF NOT EXISTS public.user_challenges (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
    challenge_id UUID REFERENCES public.challenges(id) ON DELETE CASCADE NOT NULL,
    current_value INT DEFAULT 0 NOT NULL,
    is_completed BOOLEAN DEFAULT false NOT NULL,
    completed_at TIMESTAMPTZ,
    CONSTRAINT unique_user_challenge UNIQUE(user_id, challenge_id)
);

-- --------------------------------------------------------------------
-- 12. SUBSCRIPTIONS TABLE
-- --------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.subscriptions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
    status VARCHAR(30) DEFAULT 'active' NOT NULL,
    plan_tier VARCHAR(30) DEFAULT 'premium' NOT NULL,
    original_transaction_id TEXT UNIQUE,
    current_period_start TIMESTAMPTZ NOT NULL,
    current_period_end TIMESTAMPTZ NOT NULL,
    created_at TIMESTAMPTZ DEFAULT TIMEZONE('utc', NOW()) NOT NULL
);

-- --------------------------------------------------------------------
-- 13. AI_GENERATION_LOGS TABLE
-- --------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.ai_generation_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
    prompt_context JSONB NOT NULL,
    raw_response JSONB NOT NULL,
    was_successful BOOLEAN DEFAULT true NOT NULL,
    created_at TIMESTAMPTZ DEFAULT TIMEZONE('utc', NOW()) NOT NULL
);

-- --------------------------------------------------------------------
-- INDEXES
-- --------------------------------------------------------------------
CREATE INDEX IF NOT EXISTS idx_quests_user_date ON public.quests(user_id, scheduled_date);
CREATE INDEX IF NOT EXISTS idx_xp_tx_user ON public.xp_transactions(user_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_workouts_user ON public.workouts(user_id, started_at DESC);
CREATE INDEX IF NOT EXISTS idx_workout_sets_workout ON public.workout_sets(workout_id);
CREATE INDEX IF NOT EXISTS idx_health_user_date ON public.health_daily_summaries(user_id, date);

-- --------------------------------------------------------------------
-- ROW LEVEL SECURITY (RLS) POLICIES
-- --------------------------------------------------------------------
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.hunter_stats ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.quests ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.quest_completions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.xp_transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.workouts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.workout_sets ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.health_daily_summaries ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_achievements ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_challenges ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.subscriptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.ai_generation_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.exercises ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.achievements ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.challenges ENABLE ROW LEVEL SECURITY;

-- Public read for static codexes
CREATE POLICY "Allow public read on exercises" ON public.exercises FOR SELECT USING (true);
CREATE POLICY "Allow public read on achievements" ON public.achievements FOR SELECT USING (true);
CREATE POLICY "Allow public read on challenges" ON public.challenges FOR SELECT USING (true);

-- User-scoped private access
CREATE POLICY "Users read/write own profile" ON public.profiles
    FOR ALL USING (auth.uid() = id);

CREATE POLICY "Users read own hunter_stats" ON public.hunter_stats
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users read/write own quests" ON public.quests
    FOR ALL USING (auth.uid() = user_id);

CREATE POLICY "Users read own quest_completions" ON public.quest_completions
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users read own xp_transactions" ON public.xp_transactions
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users read/write own workouts" ON public.workouts
    FOR ALL USING (auth.uid() = user_id);

CREATE POLICY "Users read/write own workout_sets" ON public.workout_sets
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.workouts w
            WHERE w.id = workout_sets.workout_id AND w.user_id = auth.uid()
        )
    );

CREATE POLICY "Users read/write own health summaries" ON public.health_daily_summaries
    FOR ALL USING (auth.uid() = user_id);

CREATE POLICY "Users read own user_achievements" ON public.user_achievements
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users read own user_challenges" ON public.user_challenges
    FOR ALL USING (auth.uid() = user_id);

CREATE POLICY "Users read own subscriptions" ON public.subscriptions
    FOR SELECT USING (auth.uid() = user_id);

-- --------------------------------------------------------------------
-- PRIVILEGED SERVER FUNCTIONS (XP Progression Engine)
-- --------------------------------------------------------------------

-- Safe Server-side function to calculate Rank from level
CREATE OR REPLACE FUNCTION public.calculate_hunter_rank(p_level INT)
RETURNS VARCHAR AS $$
BEGIN
    IF p_level >= 100 THEN RETURN 'S';
    ELSIF p_level >= 80 THEN RETURN 'A';
    ELSIF p_level >= 50 THEN RETURN 'B';
    ELSIF p_level >= 25 THEN RETURN 'C';
    ELSIF p_level >= 10 THEN RETURN 'D';
    ELSE RETURN 'E';
    END IF;
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- Safe Server-side function to award XP and update stats atomically
CREATE OR REPLACE FUNCTION public.award_hunter_xp(
    p_user_id UUID,
    p_amount INT,
    p_reason TEXT,
    p_category VARCHAR,
    p_ref_id UUID DEFAULT NULL
)
RETURNS TABLE (new_level INT, new_rank VARCHAR, new_total_xp INT) AS $$
DECLARE
    v_total_xp INT;
    v_current_level INT;
    v_needed_xp INT;
    v_new_level INT;
    v_new_rank VARCHAR;
BEGIN
    IF p_amount <= 0 THEN
        RAISE EXCEPTION 'XP amount must be positive';
    END IF;

    -- Record transaction in immutable ledger
    INSERT INTO public.xp_transactions (user_id, amount, reason, source_category, reference_id)
    VALUES (p_user_id, p_amount, p_reason, p_category, p_ref_id);

    -- Fetch current stats
    SELECT total_xp, level INTO v_total_xp, v_current_level
    FROM public.hunter_stats
    WHERE user_id = p_user_id
    FOR UPDATE;

    v_total_xp := v_total_xp + p_amount;
    v_new_level := v_current_level;

    -- Compute level according to formula: 100 + (50 * current_level)
    LOOP
        v_needed_xp := 100 + (50 * v_new_level);
        IF v_total_xp >= v_needed_xp THEN
            v_new_level := v_new_level + 1;
        ELSE
            EXIT;
        END IF;
    END LOOP;

    v_new_rank := public.calculate_hunter_rank(v_new_level);

    -- Update hunter_stats atomically
    UPDATE public.hunter_stats
    SET total_xp = v_total_xp,
        level = v_new_level,
        rank = v_new_rank,
        discipline = discipline + 1,
        strength = CASE WHEN LOWER(p_category) = 'strength' THEN strength + 2 ELSE strength END,
        agility = CASE WHEN LOWER(p_category) IN ('agility', 'walking') THEN agility + 2 ELSE agility END,
        endurance = CASE WHEN LOWER(p_category) IN ('cardio', 'endurance') THEN endurance + 2 ELSE endurance END,
        vitality = CASE WHEN LOWER(p_category) IN ('recovery', 'hydration', 'mobility') THEN vitality + 2 ELSE vitality END,
        updated_at = TIMEZONE('utc', NOW())
    WHERE user_id = p_user_id;

    RETURN QUERY SELECT v_new_level, v_new_rank, v_total_xp;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
