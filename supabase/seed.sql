-- ====================================================================
-- PROJECT HUNTER — SEED DATA
-- Exercise Library Codex, Achievements & Initial Challenges
-- ====================================================================

-- Exercises Seed
INSERT INTO public.exercises (name, category, primary_muscle, secondary_muscles, equipment, instructions, difficulty)
VALUES
('Push-Up', 'bodyweight', 'chest', ARRAY['triceps', 'shoulders', 'core'], 'none', 'Maintain neutral spine. Lower chest until 1 inch from floor, then press back up.', 'beginner'),
('Pull-Up', 'bodyweight', 'back', ARRAY['biceps', 'forearms'], 'pull_up_bar', 'Overhand grip on bar. Pull chin above bar with controlled tempo.', 'intermediate'),
('Bodyweight Squat', 'bodyweight', 'legs', ARRAY['glutes', 'quadriceps'], 'none', 'Hips back and down until thighs break parallel. Press through whole foot to stand.', 'beginner'),
('Dumbbell Floor Press', 'dumbbell', 'chest', ARRAY['triceps', 'shoulders'], 'dumbbells', 'Lie supine. Press dumbbells up from elbows resting on ground.', 'beginner'),
('Dumbbell Romanian Deadlift', 'dumbbell', 'hamstrings', ARRAY['glutes', 'lower_back'], 'dumbbells', 'Hinge at hips with soft knees, feel hamstring stretch, return to lockout.', 'intermediate'),
('Dumbbell Shoulder Press', 'dumbbell', 'shoulders', ARRAY['triceps', 'traps'], 'dumbbells', 'Press dumbbells vertically above head while bracing abdomen.', 'intermediate'),
('Plank Hold', 'bodyweight', 'core', ARRAY['shoulders', 'glutes'], 'none', 'Forearm plank with neutral spine and squeezed glutes.', 'beginner'),
('Interval Cardio Sprint', 'cardio', 'cardio', ARRAY['legs', 'lungs'], 'none', 'Alternate high output running intervals with walking recovery.', 'intermediate'),
('Spine Mobility Flow', 'mobility', 'back', ARRAY['hips', 'neck'], 'none', 'Gentle cat-cow and thoracic rotations with deep diaphragmatic breathing.', 'beginner')
ON CONFLICT (name) DO NOTHING;

-- Achievements Seed
INSERT INTO public.achievements (code, title, description, icon_name, xp_reward)
VALUES
('first_quest', 'First Blood: Awakening', 'Complete your first System-assigned daily quest.', 'bolt', 50),
('first_workout', 'Chamber Initiate', 'Execute and log your first resistance workout session.', 'fitness_center', 75),
('consistency_7_days', 'Discipline of Steel', 'Maintain an active daily quest streak for 7 consecutive days.', 'local_fire_department', 150),
('walking_milestone_10k', 'Stride Master', 'Accumulate 10,000 steps in a single daily period.', 'directions_walk', 100),
('strength_milestone', 'Monarch Strength', 'Achieve a Strength (STR) parameter of 30 or higher.', 'shield', 120),
('weekly_challenge_cleared', 'Trial Overcomer', 'Successfully complete a 7-day weekly boss challenge.', 'military_tech', 200)
ON CONFLICT (code) DO NOTHING;

-- Weekly Challenges Seed
INSERT INTO public.challenges (title, description, target_metric, target_value, duration_days, xp_reward, starts_at, ends_at)
VALUES
('Weekly Stride Trial', 'Accumulate 35,000 steps across 7 days to demonstrate hunter agility.', 'steps', 35000, 7, 200, NOW(), NOW() + INTERVAL '7 days'),
('Torso Fortification Trial', 'Complete 150 cumulative push-ups over this week.', 'reps', 150, 7, 250, NOW(), NOW() + INTERVAL '7 days');
