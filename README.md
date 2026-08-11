# PetCare Connect 🐾

A full-stack Flutter + Node.js mobile application for discovering, comparing, and booking pet-care services (vets, groomers, walkers, boarding, trainers) — built as a practice project modeled on real-world pet-care marketplace apps.

## Tech Stack

**Frontend (Mobile App)**
- Flutter & Dart
- Provider (state management)
- `http` package for REST API integration
- `shared_preferences` for local session/token persistence

**Backend (API Server)**
- Node.js + Express.js
- MongoDB + Mongoose
- JWT-based authentication
- bcryptjs for password hashing

## Features

- 🔐 User authentication (register/login) with JWT tokens
- 🔍 Browse & search service providers by category (vet, groomer, walker, boarding, trainer)
- 📋 Provider detail pages with ratings, pricing, and available time slots
- 📅 Slot-based booking system (prevents double-booking)
- 🛒 Cart & checkout flow with simulated payment confirmation
- 📖 Booking history / order tracking screen
- ⭐ Ratings & reviews module (backend ready)
- 🎯 Proper loading, empty, and error states throughout
- 📱 Responsive UI built with reusable Flutter widgets

## Project Structure

```
petcare-connect/
├── backend/                  # Node.js + Express REST API
│   ├── controllers/          # Route handler logic
│   ├── models/                # Mongoose schemas (User, Provider, Booking, Review)
│   ├── routes/                # API route definitions
│   ├── middleware/            # JWT auth middleware
│   ├── server.js
│   ├── package.json
│   └── .env.example
│
└── frontend/                  # Flutter mobile app
    ├── lib/
    │   ├── models/             # Dart data models
    │   ├── screens/            # UI screens
    │   ├── services/           # API service + Provider state management
    │   └── main.dart
    └── pubspec.yaml
```

## Backend Setup

### 1. Prerequisites
- Node.js (v18+)
- A MongoDB database — easiest option is a free [MongoDB Atlas](https://www.mongodb.com/cloud/atlas) cluster (no local install needed)

### 2. Install & configure
```bash
cd backend
npm install
cp .env.example .env
```
Open `.env` and fill in:
```
PORT=5000
MONGO_URI=your_mongodb_atlas_connection_string
JWT_SECRET=any_long_random_string
```

### 3. Run the server
```bash
npm run dev
```
Server starts at `http://localhost:5000`. You should see `MongoDB connected` and `Server running on port 5000`.

### 4. Seed demo data (important — run this once)
The app needs some providers to display. Hit this endpoint once (via browser, Postman, or curl) after the server is running:
```bash
curl -X POST http://localhost:5000/api/providers/seed/demo
```
This populates 3 demo providers (a vet, a groomer, and a dog walker) with sample slots.

### 5. Deploying the backend for free (recommended if using FlutLab)
Since FlutLab only runs Flutter code (not Node.js), deploy the backend somewhere public so your Flutter app can reach it from FlutLab or any device:
- **[Render.com](https://render.com)** — free tier, connect your GitHub repo, set the same env vars, deploy
- **[Railway.app](https://railway.app)** — similar free-tier flow

Once deployed, note your live URL (e.g. `https://petcare-connect-backend.onrender.com`).

## Frontend Setup

### Option A — Run locally (needs a decent machine)
```bash
cd frontend
flutter pub get
flutter run
```
By default the app points to `http://10.0.2.2:5000/api` (the Android emulator's alias for your laptop's localhost). If testing on a **real device**, change this in `lib/services/api_service.dart`:
```dart
static const String baseUrl = 'http://YOUR_LAPTOP_IP:5000/api';
```

### Option B — Run on FlutLab (recommended if Flutter hangs your laptop)
1. Go to [flutlab.io](https://flutlab.io) and create a free account.
2. Create a new Flutter project.
3. Upload/paste the contents of `frontend/pubspec.yaml` and everything under `frontend/lib/` into the corresponding files in FlutLab's file tree (recreate the same folder structure: `lib/models`, `lib/screens`, `lib/services`).
4. In `lib/services/api_service.dart`, update `baseUrl` to your **deployed** backend URL (see step 5 above) — FlutLab runs in the cloud and can't reach `localhost` on your laptop:
   ```dart
   static const String baseUrl = 'https://your-deployed-backend.onrender.com/api';
   ```
5. Click **Run** in FlutLab — it builds and streams a live emulator preview in your browser. No load on your laptop at all.

### Test login
Register a new account from the app's Sign Up screen, or hit the API directly:
```bash
curl -X POST http://localhost:5000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"name":"Test User","email":"test@example.com","password":"test1234","phone":"9999999999"}'
```

## API Endpoints Reference

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|----------------|
| POST | `/api/auth/register` | Register new user | No |
| POST | `/api/auth/login` | Log in | No |
| GET | `/api/auth/profile` | Get logged-in user | Yes |
| GET | `/api/providers` | List providers (filter by `?category=` `?search=`) | No |
| GET | `/api/providers/:id` | Get single provider with slots | No |
| POST | `/api/providers/seed/demo` | Seed 3 demo providers (dev only) | No |
| POST | `/api/bookings` | Create a booking | Yes |
| GET | `/api/bookings/my` | Get logged-in user's bookings | Yes |
| PATCH | `/api/bookings/:id/pay` | Mark booking as paid | Yes |
| PATCH | `/api/bookings/:id/cancel` | Cancel a booking | Yes |
| POST | `/api/reviews` | Submit a review | Yes |
| GET | `/api/reviews/provider/:providerId` | Get reviews for a provider | No |

## What This Project Demonstrates

- REST API design and integration between Flutter and a Node.js/Express backend
- Token-based authentication flow (JWT) end-to-end
- State management using the Provider pattern (auth state, cart state)
- Handling async operations, loading/error/empty states
- Reusable, componentized Flutter widget architecture
- MongoDB schema design with relational references (bookings → users, bookings → providers)
- A booking/slot-availability system with basic conflict prevention

## Possible Extensions
- Real Razorpay/Stripe payment gateway integration (currently simulated via `markBookingPaid`)
- Firebase Cloud Messaging for real push notifications on booking confirmation
- Google Maps integration to show provider locations
- Image upload for pet profiles

## Author
Shweta Umbrajkar — [GitHub](https://github.com/ShwetaUmbrajkar)
