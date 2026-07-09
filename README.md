# Smart Travel

**Smart Travel** is a Flutter-based tourism application that helps users explore destinations, compare transportation options, find suitable accommodations, view tours and attractions, and manage reservations in one place.

The application uses Firebase services to store and manage travel-related data, user reservations, reviews, booking status, tracking codes, and image path metadata.

---

## Developer

**Delaram Doroudgarian**  
Student ID: **5881909**  
Email: **delaramdoroud82@gmail.com**  
Course: **Mobile Development**

---

## Project Overview

Smart Travel provides a centralized travel planning experience. Instead of using multiple separate platforms for transportation, accommodation, tours, and destination discovery, users can access the main travel-related services from a single mobile application.

From the Home Page, users can browse recommended transports, accommodations, and tours, open detailed pages for each item, and reserve suitable options directly through the app.

One of the key implemented features is the **Smart Travel Planner**. This feature allows users to select an origin, destination, budget, trip duration, and number of travelers. Based on these inputs, the application recommends suitable transportation and accommodation options, estimates the total trip cost, and displays the results as interactive cards that can be opened for details and booking.

---

## Main Features

- User registration and login
- Destination discovery
- Transportation browsing and reservation
- One-way and round-trip transportation flow
- Accommodation browsing and booking
- Tour browsing and reservation
- Tourist attraction browsing
- Attraction detail pages with map preview and directions
- Smart Travel Planner with personalized recommendations
- Reviews and ratings
- My Reservations page
- History page for completed bookings
- Booking tracking code generation
- PDF booking confirmation generation and sharing
- User profile management
- Online support page
- GPS-based directions support

---

## Functional Requirements

The Smart Travel application supports the main travel planning and reservation flow through the following requirements:

- Users can register and log in.
- Users can browse recommended travel services from the Home Page.
- Users can view transports, accommodations, tours, and attractions.
- Users can filter and sort travel services.
- Users can open detail pages for each travel item.
- Users can reserve transportation, accommodation, and tour items.
- Users can complete a simulated booking confirmation through the Book Now action.
- Users can view active reservations in My Reservations.
- Users can view finalized bookings in History.
- Users can download or share PDF booking confirmations.
- Users can submit reviews and ratings.
- Users can request support through the Online Support page.
- Users can use map previews and directions for accommodations and attractions.

---

## Application Screens

### Home Page

The Home Page provides quick access to the main travel services in the application. It displays recommended transports, accommodations, and tours using horizontal card sections. Each card shows summary information such as image, title, destination or route, price, and date when available.

Users can tap a card to open its detail page or use the **More** button to view the full list of items for that category.

The page also includes a hamburger menu with additional options such as:

- My Reservations
- History
- Tourist Attractions
- Help & Support
- About

---

### Reservation Page

The Reservation Page allows users to browse and compare available travel services. Depending on the selected category, users can view:

- Transportation options
- Accommodations
- Tours

The page supports filtering. Transports and tours also support sorting by price or date, while accommodations are displayed by price by default. Selecting a card opens the related detail page for more information and booking.

---

### Transportation Reservation and Round-Trip Flow

The transportation reservation flow allows users to search for available routes between cities.

Users can choose either:

- One-way trip
- Round-trip mode

In round-trip mode, the user first selects an outbound ticket and then selects a return ticket. After both tickets are selected, the application opens the detail page with the combined round-trip information ready for booking.

---

### Details Page

The Details Page presents complete information about the selected travel item. It displays:

- Images
- Title
- Price
- Route or destination information
- Description
- Ratings
- Related content
- Reviews section

Users can view existing feedback or submit their own rating and comment.

For accommodations, the page also shows:

- Maximum guests
- Bedrooms
- Beds
- Bathrooms
- Amenities
- Room options
- Location

For transports, users can select the number of passengers, and the total price updates based on the passenger count. The page also displays remaining capacity for transports and tours.

---

### Accommodation Details and Booking

The accommodation details section shows the main stay information, including nightly price, guest capacity, bedrooms, beds, bathrooms, and amenities.

It also includes:

- Map preview
- Directions support
- Stay date selection
- Room type selection
- Automatic total price calculation

Booked accommodation dates are checked against existing finalized bookings. If the selected room type or stay is no longer available for the selected dates, the application prevents the booking.

---

### Smart Travel Planner

The Smart Travel Planner helps users generate a personalized travel plan.

Users enter:

- Origin
- Destination
- Budget
- Trip duration
- Number of travelers

Based on these inputs, the application recommends suitable transportation and accommodation options, estimates the total trip cost, and displays the recommended items as interactive cards.

---

### My Reservations and History Page

The **My Reservations** page shows the user’s saved reservations and allows them to review or remove active reserved items.

The **History** page shows completed bookings after the user clicks **Book Now**. Booked items include:

- Tracking code
- Booking details
- PDF download option

---

### Attractions and Attraction Details Page

The Attractions Page allows users to explore available attractions for different destinations. Each attraction includes visual content and basic information such as name, category, and ticket price.

The Attraction Details Page provides more detailed information, including:

- Images
- Description
- Category
- Ticket information
- Location details
- Map preview
- Directions support

---

### User Account and Profile Page

The User Account page allows users to view and manage their profile information. It provides access to account-related actions such as editing profile details, viewing reservations, and managing the user experience within the application.

---

### Login and Register Pages

The Login and Register pages handle user authentication.

New users can create an account, while existing users can sign in to access reservation features, user-specific data, saved bookings, and reviews.

Authentication ensures that reservations and reviews are connected to the correct user.

---

### Online Support Page

The Online Support page allows users to request help related to travel planning, reservations, or general application usage.

Users can describe their issue or question so that support can assist them with their travel-related needs.

---

## Technical Architecture

### Platform

Smart Travel was developed using:

- **Flutter**
- **Dart**
- **Firebase**

Flutter was selected because it allows the application to run on multiple supported platforms from a single codebase while maintaining a consistent user interface and development structure.

Firebase was used as the backend service. It provides authentication, Firestore database storage, and real-time data updates. This allows the application to manage users, travel items, reservations, reviews, and application content without requiring a separate custom backend server.

The project follows a structured Flutter architecture by separating:

- Screens
- Reusable components
- Widgets
- Models
- Data access logic
- Theme-related files

This separation makes the application easier to maintain and extend.

---

## Reason for Technology Choices

### Cross-Platform Development

Flutter allows the application to be developed for multiple platforms using a single codebase. This reduces development time and keeps the user experience consistent across devices.

### Reusable UI Components

Flutter’s widget-based structure is suitable for building reusable interface components such as travel cards, carousel sections, detail pages, input fields, and booking controls.

Examples of reusable components include:

- `DetailsFrame`
- `HomeSectionCarousel`
- Shared input widgets

### Fast Development Process

Flutter features such as Hot Reload and Hot Restart made it easier to test UI changes quickly during development.

This was useful when improving:

- Home page cards
- Reservation screens
- Smart Travel Planner
- Detail page layouts

### Firebase Integration

Firebase was used to manage backend functionality, including:

- User authentication
- Firestore collections
- Reservations
- Reviews
- Booking-related records
- Image-related data

### Dynamic Data Handling

Firestore allows the application to retrieve and display updated data for transports, accommodations, tours, attractions, reservations, and reviews.

### Model-Based Data Structure

Firestore data is converted into Dart model objects such as:

- `Transport`
- `Accommodation`
- `Tour`
- `Attraction`
- `Destination`

This makes the code cleaner, improves readability, and reduces direct map-reading inside UI files.

---

## Backend and Data Management

### Data Persistence

The Smart Travel application uses cloud-based storage solutions to store and manage dynamic travel data.

Firebase is used as the main backend platform for handling:

- Authentication
- Database records
- Reservations
- Reviews
- Booking status
- Tracking codes
- Image path metadata

### Cloud Database

Cloud Firestore is used as the primary database for storing:

- Destinations
- Transports
- Accommodations
- Tours
- Attractions
- User reservations
- Reviews
- Capacity values
- Booking-related records

### User Reservations

User bookings are stored in the `my_reservations` collection.

Each reservation includes information such as:

- User ID
- Selected item
- Item type
- Price
- Dates
- Transport tickets
- Room details
- Booking status
- Tracking code
- Other booking-related data

### Reviews and Ratings

Reviews are stored separately and connected to items using:

- `targetType`
- `targetId`

This allows the application to manage ratings and comments for different item types such as accommodations, transports, tours, and attractions.

### Image Data

Travel item images are stored locally in the `images/` folder, while their image paths are saved in Firestore and used by the app to display the correct visuals.

---

## State Management

The project mainly uses Flutter’s built-in state management approach with:

- `StatefulWidget`
- `setState`
- Controllers
- Streams
- `StreamBuilder`

### Local UI State

`setState` is used in screens such as Reservation, Smart Travel, Details Page, and form-based pages to update the interface when the user changes filters, selects tickets, chooses stay dates, or submits data.

### Text Controllers

`TextEditingController` is used for handling user inputs such as:

- Budget
- Trip duration
- Traveler count
- Login fields
- Registration fields
- Profile editing fields

### Stream-Based Updates

Firestore streams combined with `StreamBuilder` are used to display updated backend data in pages such as:

- Home
- Reservation
- Smart Travel
- My Reservations
- Attractions
- Details Page
- Reviews

---

## Hardware and Device Features

The application uses several device-related features to support travel browsing, location awareness, and reservation-related interactions.

### Internet Connectivity

The app relies on internet access to communicate with Firebase services, load Firestore data, authenticate users, submit reviews, and save reservations.

### Location Services / GPS

The application uses the device’s current location when users request directions to an accommodation or attraction.

When the Directions button is pressed, the app checks whether location services are enabled, requests location permission if needed, and uses the current GPS position as the starting point for navigation.

### External App Launching

The app uses external application launching to open Google Maps or a compatible navigation app for route guidance.

---

## External Libraries and Dependencies

The project uses several external packages:

### Firebase

- `firebase_core`
- `firebase_auth`
- `cloud_firestore`
- `firebase_app_check`
- `firebase_storage`

These packages are used for Firebase initialization, authentication, Firestore database access, app verification, and storage support.

### Date and Time Formatting

- `intl`

Used to format dates for transports, tours, reservations, and booking-related information.

### UI Styling

- `google_fonts`

Used to apply custom typography across the application.

### Navigation and External Links

- `url_launcher`

Used to open external links such as map directions or location-related navigation.

### Location Services

- `geolocator`

Used to check location service status, request location permissions, and retrieve the user's current GPS position for directions.

### Assets and Icons

- `cupertino_icons`

Provides additional icon support.

Local image assets are stored in the `images/` folder.

### PDF Generation and Sharing

- `pdf`
- `printing`

Used to generate booking confirmation PDFs and allow users to save or share completed booking details from the History page.

---

## Development Challenges and Solutions

### UI/UX Challenges

One of the main challenges was designing a consistent interface for different travel services such as transports, accommodations, tours, and attractions.

Each item type required different information, but the application still needed a unified visual style.

This was handled by creating reusable components such as:

- `DetailsFrame`
- `HomeSectionCarousel`
- Input fields
- Shared detail page layouts

These components helped reduce repeated UI code and kept the design consistent across Home, Reservation, and Details pages.

---

### Smart Travel Recommendation Logic

The Smart Travel Planner required extra logic because recommendations depend on multiple user inputs, including origin, destination, budget, duration, and number of travelers.

A key issue was calculating accommodation cost correctly. Since accommodation prices are based on rooms or units rather than individual travelers, the calculation was updated to consider the accommodation capacity and number of required units instead of simply multiplying by the number of travelers.

---

### Round-Trip Transportation Flow

Round-trip transportation required a different flow from one-way transport booking.

The user first needs to select an outbound ticket and then a return ticket before opening the details page.

This was solved by creating a separate round-trip selection flow that stores the selected outbound transport, displays it to the user, and then allows the return ticket to be selected before generating the combined transport booking details.

---

### Maps and Location Handling

Adding directions support introduced challenges related to location permissions and device settings.

The application needed to handle cases where:

- Location services were disabled
- Permission was denied
- Permission was permanently denied

This was solved by using the `geolocator` package to check location service status, request permission, retrieve the current GPS position, and show appropriate messages when location access was not available.

---

### Booking Availability and Capacity Management

Another challenge was preventing finalized bookings from being duplicated.

Accommodation bookings required date and room availability checks, while transports and tours required remaining capacity tracking.

This was handled by storing `bookingStatus` values, checking finalized bookings before confirmation, and reducing transport or tour capacity only when the user completes the **Book Now** action.

---

## Use of Generative AI

Generative AI tools were used as support tools during the project.

Since the developer had previously worked with Flutter several years ago but had not used it regularly since then, AI was helpful for refreshing Flutter syntax, widget structure, navigation, state handling, and common Flutter development patterns.

AI was also useful during debugging. When build errors, emulator issues, dependency problems, or implementation bugs appeared, AI helped explain possible causes and suggested practical steps to investigate and fix them.

### Tools Used

#### ChatGPT

ChatGPT was used during the coding and implementation phase of the project. It was also used as a support tool for UI design decisions, including improving card layouts, organizing page sections, refining form behavior, and making the Smart Travel recommendation results more user-friendly and visually consistent with the rest of the application.

#### Gemini

Gemini was mainly used for editing and polishing the final report. It helped refine wording, improve clarity, and make the final document more consistent and professional before submission.

---

## Testing and Evaluation

Manual testing was carried out throughout the development process to check the main travel planning, reservation, booking, history, profile, and PDF confirmation flows.

Testing focused on ensuring that users could move smoothly from browsing items to reserving, booking, and viewing finalized bookings in History.

### Issues Found and Fixed

- Reserving the same accommodation for different dates overwrote the previous reservation instead of creating a separate record.
- Booked items in the History page were still behaving like active clickable reservation items.
- The PDF confirmation did not display the user’s name and surname because they were stored in the `users` collection, not directly inside the reservation document.
- Accommodation dates that were already booked were not always disabled correctly in the date picker.
- Book Now did not always show the expected success message after moving an item to History.
- Transport and tour bookings needed capacity checks so users could not book more seats than the remaining capacity.
- Some error messages did not use a clear red background, making them less noticeable.
- Adding new profile fields caused form validation issues because multiple forms were using the same `GlobalKey`.

---

## Conclusion

The Smart Travel project successfully developed a Flutter-based tourism application that allows users to explore destinations, compare transports, view accommodations, browse tours and attractions, submit reviews, and manage reservations in one place.

The application also includes a Smart Travel Planner that recommends suitable transportation and accommodation options based on user inputs such as origin, destination, budget, trip duration, and number of travelers.

Map previews and GPS-based directions were also implemented for accommodations and attractions.

Overall, the project demonstrates a functional travel planning and reservation system using Flutter, Firebase, reusable UI components, model-based data handling, and location-related features.

---

## Future Improvements

Although the current version of Smart Travel is functional, several improvements could make the application more advanced and easier to manage.

### AI-Based Recommendation System

The current Smart Travel Planner recommends transportation and accommodation based on selected user inputs. Future versions could integrate an AI API to generate more personalized travel suggestions based on:

- User preferences
- Travel style
- Budget
- Season
- Ratings
- Destination characteristics

### Payment System

A complete payment system could be added in the future. Once the payment is successfully completed, the system could automatically send a confirmation email containing:

- Reservation details
- Payment status
- Booking information

### Admin Dashboard

A full admin dashboard could be developed to manage travel data such as:

- Destinations
- Accommodations
- Transports
- Tours
- Attractions

This would allow administrators to add, edit, and remove travel content through a user interface instead of manually updating Firestore or seed data.

---

## References

- [Flutter Documentation](https://flutter.dev/)
- [Firebase Documentation](https://firebase.google.com/docs)
