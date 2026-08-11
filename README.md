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
