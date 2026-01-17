# assign-admin Cloud Function

This is an example Node.js Cloud Function to securely assign the `admin` role to a user.

Usage:
1. Deploy to your serverless provider (Vercel, Netlify Functions, Cloud Run, etc.).
2. Set environment variables `SUPABASE_URL` and `SERVICE_ROLE_KEY` (the service role key from Supabase).
3. Call the endpoint with a POST JSON body: `{ "user_id": "<supabase-user-id>" }`.

Security: Only authorized staff should be allowed to call this endpoint. Protect it with API keys, auth/ACLs, or IP restrictions.

Example response:
{
  "ok": true,
  "data": [ ...updated rows... ]
}
