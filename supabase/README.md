# PROJECT HUNTER — SUPABASE BACKEND SETUP GUIDE

This directory contains the database schema, Row Level Security (RLS) policies, seed data, and Edge Functions for **PROJECT HUNTER**.

---

## 1. Quick Database Initialization

### Using Supabase CLI:
```bash
# 1. Install Supabase CLI (if not already installed)
npm install -g supabase

# 2. Link your local project to your remote Supabase project
supabase link --project-ref <your-supabase-project-id>

# 3. Apply schema migration
supabase db push

# 4. Apply seed data
supabase db reset
# or run seed.sql in the SQL Editor
```

### Using Supabase Web Dashboard:
1. Open your Supabase project at [https://supabase.com/dashboard](https://supabase.com/dashboard).
2. Go to **SQL Editor**.
3. Copy and run the contents of:
   `supabase/migrations/20261121000001_project_hunter_schema.sql`
4. Copy and run the contents of:
   `supabase/seed.sql`

---

## 2. Environment Variables Configuration

Set these variables in your Flutter environment:

```bash
# In your launch configuration or flutter run command:
flutter run --dart-define=SUPABASE_URL=https://<your-project>.supabase.co --dart-define=SUPABASE_ANON_KEY=<your-anon-key>
```

---

## 3. Deploying the Gemini AI Edge Function

1. Set your Gemini API key in Supabase secrets:
   ```bash
   supabase secrets set GEMINI_API_KEY="your-gemini-api-key"
   ```
2. Deploy the edge function:
   ```bash
   supabase functions deploy generate-daily-quests
   ```

---

## 4. Security & RLS Verification

All tables enforce Row Level Security:
- Clients cannot directly overwrite `hunter_stats`, `xp_transactions`, or ranks.
- Privileged progression updates use the PostgreSQL function `public.award_hunter_xp()`.
- Unique constraints prevent duplicate completions (`user_id, quest_id`).
