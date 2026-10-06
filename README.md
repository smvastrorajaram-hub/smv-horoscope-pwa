# SMV HOROSCOPE independent GitHub Pages PWA

This repository contains only the deployment workflow. The live app source is always pulled from:

`smvastrorajaram-hub/smvastroservices` → `public/horoscope/`

Target custom domain:

`horoscope.smvastroservices.in`

## First setup

1. Create this repository as a **Public** GitHub repository.
2. Upload these files preserving `.github/workflows/deploy-pages.yml`.
3. Repository **Settings → Pages → Build and deployment → Source → GitHub Actions**.
4. **Actions → Deploy SMV HOROSCOPE PWA → Run workflow**.
5. After the first successful deployment, **Settings → Pages → Custom domain**:
   `horoscope.smvastroservices.in`
6. At your DNS provider create:
   - Type: `CNAME`
   - Name/Host: `horoscope`
   - Target: `smvastrorajaram-hub.github.io`
7. Firebase Console → Authentication → Settings → Authorized domains:
   add `horoscope.smvastroservices.in`.

No PAT/token is required because this workflow only reads the public main repository and deploys to its own Pages site.

The workflow also checks the main source every 6 hours. Use **Run workflow** after an important SMV ASTRO update when you want immediate sync.
