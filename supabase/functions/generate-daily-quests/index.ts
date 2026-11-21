// ====================================================================
// PROJECT HUNTER — SUPABASE EDGE FUNCTION: GENERATE DAILY QUESTS
// Server-Side Gemini AI Integration with Safety Constraints
// ====================================================================

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";

const GEMINI_API_KEY = Deno.env.get("GEMINI_API_KEY") || "";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const { hunter_level, fitness_goals, limitations } = await req.json();

    const systemPrompt = `You are the mysterious fitness System of PROJECT HUNTER, an RPG fitness application.
Your mission is to generate balanced, safe daily physical quests for a hunter.

RULES:
- Return ONLY valid structured JSON matching the requested schema.
- Do not recommend dangerous workouts or training through pain.
- Respect injuries and limitations: ${JSON.stringify(limitations || [])}.
- Goals: ${JSON.stringify(fitness_goals || [])}.
- Hunter Level: ${hunter_level || '1'}.
- Standard XP reward must be between 20 and 70 XP per quest.
- Duration must be between 5 and 45 minutes.

SCHEMA:
{
  "date": "YYYY-MM-DD",
  "daily_message": "String",
  "quests": [
    {
      "title": "String",
      "category": "strength" | "cardio" | "walking" | "mobility" | "recovery" | "hydration",
      "difficulty": "beginner" | "intermediate" | "advanced",
      "description": "String",
      "target_metric": "reps" | "steps" | "seconds" | "ml" | "minutes",
      "target_value": number,
      "target_unit": "String",
      "duration_minutes": number,
      "xp_reward": number,
      "verification_method": "manual" | "healthConnect"
    }
  ]
}`;

    const geminiUrl = `https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=${GEMINI_API_KEY}`;

    const aiResponse = await fetch(geminiUrl, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        contents: [{ parts: [{ text: systemPrompt }] }],
        generationConfig: {
          response_mime_type: "application/json",
          temperature: 0.7,
        },
      }),
    });

    const aiData = await aiResponse.json();
    const candidateText = aiData?.candidates?.[0]?.content?.parts?.[0]?.text;

    if (!candidateText) {
      throw new Error("Empty response from AI engine");
    }

    const parsedQuests = JSON.parse(candidateText);

    return new Response(JSON.stringify(parsedQuests), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
      status: 200,
    });
  } catch (error) {
    return new Response(
      JSON.stringify({ error: error.message || "Failed to generate quests" }),
      {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
        status: 500,
      }
    );
  }
});
