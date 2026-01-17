// Example Cloud Function (Node.js) to assign admin role safely using Supabase Service Role Key
// WARNING: Store SERVICE_ROLE_KEY securely (environment variable), never expose it to clients.

const { createClient } = require('@supabase/supabase-js');

const SUPABASE_URL = process.env.SUPABASE_URL;
const SERVICE_ROLE_KEY = process.env.SERVICE_ROLE_KEY; // set in your server env

const supabase = createClient(SUPABASE_URL, SERVICE_ROLE_KEY);

// Example express handler
module.exports = async function (req, res) {
  try {
    const { user_id } = req.body;
    if (!user_id) return res.status(400).json({ error: 'user_id required' });

    // Update profiles table role to 'admin'
    const { data, error } = await supabase.from('profiles').update({ role: 'admin' }).eq('id', user_id);
    if (error) {
      return res.status(500).json({ error: error.message });
    }

    return res.json({ ok: true, data });
  } catch (e) {
    return res.status(500).json({ error: e.message });
  }
};
