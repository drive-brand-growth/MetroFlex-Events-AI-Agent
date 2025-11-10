# Render.com Deployment Guide - MetroFlex AI Agent
## Easiest Deployment (No CLI Required!)

**Deployment Time:** 5-10 minutes
**Performance:** Excellent (99.9% uptime, fast US-based hosting)
**Cost:** Free tier or $7/mo for always-on service

---

## 🌟 Why Render is the Easiest Option

✅ **No CLI required** - Everything done in web dashboard
✅ **Auto-deploy from GitHub** - Push code, auto-deploys
✅ **Free tier available** - No credit card needed for testing
✅ **Simple setup** - Just connect GitHub repo
✅ **Great documentation** - Easy to troubleshoot
✅ **99.9% uptime** - Reliable and stable

---

## 🚀 Step-by-Step Deployment (5 Minutes)

### Step 1: Sign Up for Render

1. Go to: **https://render.com**
2. Click **"Get Started for Free"**
3. Sign up with **GitHub** (recommended - enables auto-deploy)

---

### Step 2: Connect Your Repository

1. In Render dashboard, click **"New +"** → **"Web Service"**
2. Click **"Connect account"** to link GitHub
3. Find and select: **`MetroFlex-Events-AI-Agent`**
4. Click **"Connect"**

---

### Step 3: Configure Your Service

Render will auto-detect it's a Python app. Configure these settings:

**Basic Settings:**
- **Name:** `metroflex-ai-agent`
- **Region:** Oregon or Ohio (closest to Texas)
- **Branch:** `main` (or your feature branch)
- **Root Directory:** Leave blank

**Build Settings:**
- **Build Command:**
  ```
  pip install -r AI_Agent/requirements.txt
  ```

- **Start Command:**
  ```
  cd AI_Agent && gunicorn app:app --bind 0.0.0.0:$PORT --workers 2 --threads 4 --timeout 120 --worker-class gthread
  ```

**Plan:**
- **Free** (spins down after inactivity - 1-2 min startup)
- **Starter ($7/mo)** - Always on, no spin-down ⭐ **Recommended**

---

### Step 4: Add Environment Variables

In the **"Environment"** section, add:

| Key | Value |
|-----|-------|
| `FLASK_ENV` | `production` |
| `OPENAI_API_KEY` | `sk-proj-your-actual-key-here` |

**Important:** Keep `OPENAI_API_KEY` **secret** (don't share publicly)

---

### Step 5: Deploy!

1. Click **"Create Web Service"**
2. Render will build and deploy (takes 2-5 minutes)
3. Watch the build logs in real-time
4. When complete, you'll see: **"Live ✅"**

**Your URL:** `https://metroflex-ai-agent.onrender.com`

---

## ✅ Verify Deployment

### Test Health Endpoint

Visit in browser:
```
https://metroflex-ai-agent.onrender.com/health
```

**Expected response:**
```json
{
  "status": "healthy",
  "agent": "MetroFlex AI Assistant"
}
```

### Test Chat Endpoint

Use curl or Postman:
```bash
curl -X POST https://metroflex-ai-agent.onrender.com/webhook/chat \
  -H "Content-Type: application/json" \
  -d '{
    "message": "When is the Ronnie Coleman Classic?",
    "user_id": "test_user"
  }'
```

**Expected response:**
```json
{
  "success": true,
  "response": "The Ronnie Coleman Classic 30th Anniversary is on May 17, 2025...",
  "timestamp": "2025-01-10T12:00:00"
}
```

---

## 🔄 Auto-Deploy (Set It & Forget It)

Once configured, Render auto-deploys on every git push:

```bash
# Make changes to your code
git add .
git commit -m "Update knowledge base"
git push origin main

# Render automatically:
# 1. Detects the push
# 2. Builds new container
# 3. Deploys automatically
# 4. Zero downtime deployment
```

**Watch deployments:** Render dashboard → Logs

---

## 🌍 Update Your Chat Widget

After deployment, update `AI_Agent/GHL_CHAT_WIDGET.html`:

**Line 395**, change:
```javascript
const response = await fetch('YOUR_WEBHOOK_URL', {
```

**To:**
```javascript
const response = await fetch('https://metroflex-ai-agent.onrender.com/webhook/chat', {
```

Then deploy the widget to GoHighLevel.

---

## 💰 Cost Breakdown

### Free Tier
- **Price:** $0/month
- **Limitations:**
  - Spins down after 15 min of inactivity
  - 1-2 minute cold start when someone visits
  - 750 hours/month free runtime
- **Best for:** Testing, low-traffic sites

### Starter Tier ⭐ **Recommended**
- **Price:** $7/month
- **Features:**
  - Always on (no spin-down)
  - 512MB RAM
  - Unlimited hours
  - 99.9% uptime
  - Custom domains
- **Best for:** Production use

### Pro Tier
- **Price:** $25/month
- **Features:**
  - 2GB RAM
  - Auto-scaling
  - Priority support
  - Advanced metrics
- **Best for:** High-traffic sites (1000+ chats/day)

---

## 🔧 Configuration Options

### Change Region (Lower Latency)

In Render dashboard:
1. Go to your service
2. **Settings** → **Region**
3. Choose closest to your users:
   - **Ohio** (closer to Texas)
   - **Oregon** (West Coast)
   - **Frankfurt** (Europe)
   - **Singapore** (Asia)

### Scale Resources (More Traffic)

**Settings** → **Plan:**
- Upgrade to **Pro** for 2GB RAM
- Handles 500+ concurrent users

### Custom Domain

**Settings** → **Custom Domains:**
1. Add your domain (e.g., `api.metroflexevents.com`)
2. Update DNS records (Render provides instructions)
3. Free SSL certificate included

---

## 📊 Monitoring & Logs

### View Real-Time Logs

Render dashboard → **Logs** tab:
- See all requests
- Debug errors
- Monitor performance

### Metrics (Pro Plan)

- Request volume
- Response times
- Error rates
- CPU/Memory usage

### Alerts

**Settings** → **Notifications:**
- Email alerts for downtime
- Slack integration
- Webhook notifications

---

## 🐛 Troubleshooting

### Issue: Build Fails

**Check build logs** in Render dashboard.

**Common fixes:**
```bash
# Verify requirements.txt exists
ls AI_Agent/requirements.txt

# Test locally first
cd AI_Agent
pip install -r requirements.txt
python app.py
```

### Issue: "Application Failed to Respond"

**Check:**
1. **Start command** uses correct port: `$PORT` (Render provides this)
2. **Health check path** is `/health`
3. **OpenAI API key** is set in environment variables

**Verify locally:**
```bash
cd AI_Agent
export OPENAI_API_KEY=sk-proj-xxx
export PORT=5000
python app.py
curl http://localhost:5000/health
```

### Issue: Slow Cold Starts (Free Tier)

**Solution:** Upgrade to **Starter plan ($7/mo)** for always-on service.

**Alternative:** Use cron job to ping every 10 minutes:
```bash
# Use a service like cron-job.org to ping:
https://metroflex-ai-agent.onrender.com/health
```

### Issue: OpenAI Rate Limits

**Check usage:** https://platform.openai.com/usage

**Add rate limiting** in `AI_Agent/app.py`:
```python
from flask_limiter import Limiter

limiter = Limiter(app, key_func=lambda: request.remote_addr)

@app.route('/webhook/chat', methods=['POST'])
@limiter.limit("30 per minute")
def ghl_webhook():
    # ... existing code
```

---

## 🔒 Security Best Practices

### 1. Environment Variables (Never Commit Secrets)

✅ **Good:** Set in Render dashboard (encrypted)
❌ **Bad:** Commit to GitHub in `.env` file

### 2. HTTPS (Free SSL)

Render provides **free SSL certificates** automatically.
Your URL is always `https://` (secure).

### 3. Rate Limiting (Prevent Abuse)

Add Flask-Limiter to prevent spam:
```bash
pip install flask-limiter
```

### 4. CORS Configuration

Already configured in `AI_Agent/app.py`:
```python
from flask_cors import CORS
CORS(app)  # Allow requests from GHL website
```

---

## 📈 Performance Optimization

### 1. Use Gunicorn Workers

Already configured in start command:
```
--workers 2 --threads 4
```

**Handles:** 50-100 concurrent requests

### 2. Optimize OpenAI Calls

In `AI_Agent/app.py`, adjust:
```python
max_tokens=300  # Shorter responses = faster + cheaper
temperature=0.7  # Balance creativity vs speed
```

### 3. Cache Common Responses (Advanced)

Add Redis caching for frequent questions:
```bash
# In Render, add Redis add-on
# Then cache responses for 1 hour
```

---

## 🔄 Alternative: Use `render.yaml` (Infrastructure as Code)

For advanced users, deploy via config file:

**Already created:** `render.yaml` in your repo

**To use:**
1. Render dashboard → **"New +"** → **"Blueprint"**
2. Connect GitHub repo
3. Render reads `render.yaml` automatically
4. Click **"Apply"**

**Benefits:**
- Version control your infrastructure
- Easy to replicate environments
- Team collaboration

---

## 📊 Performance Benchmarks

### Expected Performance (Render)

| Metric | Free Tier | Starter ($7/mo) |
|--------|-----------|-----------------|
| **Response Time** | 1-3s (after cold start) | <1.5s |
| **Cold Start** | 1-2 min | None (always on) |
| **Uptime** | 99%+ | 99.9% |
| **Concurrent Users** | 10-20 | 50-100 |
| **Build Time** | 2-5 min | 2-5 min |

### Render vs Competitors

| Feature | Render | Fly.io | Railway | Heroku |
|---------|--------|--------|---------|--------|
| **Setup Ease** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| **Performance** | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ |
| **Free Tier** | ✅ No CC | ✅ Requires CC | ❌ | ❌ |
| **Auto-Deploy** | ✅ | ❌ Manual | ✅ | ✅ |
| **Uptime** | 99.9% | 99.99% | 99% | 99.95% |
| **Price** | $7/mo | $5/mo | $5/mo | $7/mo |

---

## 🎯 When to Choose Render

Choose **Render** if:
- ✅ You want the **easiest setup** (web dashboard only)
- ✅ You're **not technical** (no CLI needed)
- ✅ You want **auto-deploy** from GitHub
- ✅ You want to **test free first** (no credit card)
- ✅ Your users are **US-based** (Texas events)

Choose **Fly.io** if:
- ✅ You need **global edge computing**
- ✅ You want **<100ms latency worldwide**
- ✅ You need **99.99% uptime SLA**
- ✅ You're comfortable with **CLI tools**

---

## ✅ Deployment Checklist

- [ ] Sign up for Render.com (with GitHub)
- [ ] Create new Web Service
- [ ] Connect GitHub repo
- [ ] Configure build command
- [ ] Configure start command
- [ ] Add environment variables (`OPENAI_API_KEY`)
- [ ] Choose plan (Free or Starter $7/mo)
- [ ] Deploy and wait for build
- [ ] Test `/health` endpoint
- [ ] Test `/webhook/chat` endpoint
- [ ] Update GHL chat widget URL
- [ ] Deploy widget to GoHighLevel
- [ ] Monitor logs for 24 hours

---

## 📞 Support & Resources

### Render Documentation
- **Docs:** https://render.com/docs
- **Community:** https://community.render.com
- **Status:** https://status.render.com

### MetroFlex Agent Support
- **Dashboard:** https://dashboard.render.com
- **Logs:** View in dashboard → Logs tab
- **Health:** `https://metroflex-ai-agent.onrender.com/health`

---

## 🎉 You're Live!

Your MetroFlex AI Agent is now running on **Render** with:

✅ **Easy setup** (no CLI required)
✅ **Auto-deploy** from GitHub
✅ **99.9% uptime**
✅ **Free tier or $7/mo**
✅ **Simple dashboard** for monitoring

**Your URL:** `https://metroflex-ai-agent.onrender.com`

---

## 🆚 Quick Comparison Summary

| What You Value Most | Choose |
|---------------------|--------|
| **Easiest setup** | 🏆 **Render** |
| **Best performance** | 🏆 **Fly.io** |
| **No credit card** | 🏆 **Render** |
| **Global edge** | 🏆 **Fly.io** |
| **Web dashboard** | 🏆 **Render** |
| **CLI power user** | 🏆 **Fly.io** |

**Both are excellent choices!** Pick based on your preferences.

---

**Next Step:** Sign up at **https://render.com** and follow the steps above! 🚀
