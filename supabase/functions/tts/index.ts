import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { Communicate } from "npm:edge-tts-universal"

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    let text, voice;
    if (req.method === 'POST') {
      const body = await req.json()
      text = body.text
      voice = body.voice || 'en-US-AriaNeural'
    } else {
      const url = new URL(req.url)
      text = url.searchParams.get('text')
      voice = url.searchParams.get('voice') || 'en-US-AriaNeural'
    }
    
    if (!text) {
      return new Response(JSON.stringify({ error: 'Text is required' }), {
        status: 400,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      })
    }

    const communicate = new Communicate(text, voice)
    
    const stream = new ReadableStream({
      async start(controller) {
        try {
          for await (const chunk of communicate.stream()) {
            if (chunk.type === 'audio') {
              controller.enqueue(chunk.data)
            }
          }
          controller.close()
        } catch (e) {
          controller.error(e)
        }
      }
    })

    return new Response(stream, {
      headers: {
        ...corsHeaders,
        'Content-Type': 'audio/mpeg',
      },
    })
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), {
      status: 500,
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    })
  }
})
