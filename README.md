# GitHub User Profile App

## Introduction
This app fetches a list of GitHub users and displays their profiles upon selection. It adheres to best practices for iOS UX and UI principles and meets the specified requirements using Swift 5.2, UIKit, AutoLayout, and CoreData. 

## Features

### General
1. **GitHub Users List**: Displays a list of GitHub users using `UITableView`.
2. **Profile View**: Fetches and displays a selected user's profile data.
3. **Responsive Design**: The app follows Apple's Human Interface Guidelines (HIGs) and supports dark mode.

### Technical Requirements
1. **Swift 5.2 and Xcode**: Developed using the latest official release targeting iOS 14.
2. **CoreData**: Utilized for data persistence.
3. **UIKit and AutoLayout**: UI built using UIKit and AutoLayout.
4. **Network Queue**: All network calls are queued.
5. **Media Caching**: All media are cached on disk.
6. **APIs**: Uses only Apple's APIs for GitHub requests, image loading, and CoreData integration.
7. **Codable**: Models fetched from the API are parsed using Codable.
8. **Unit Tests**: Not written, need some time to learn.
9. **MVVM Pattern**: The app follows the MVVM architectural pattern.

### GitHub Users
1. **Offline Mode**: Works offline if data has been previously loaded.
2. **No Internet Handling**: Displays appropriate UI indicators and retries loading data once the connection is available.
3. **Data Display**: Shows saved data from previous launches first, then fetches new data in parallel.
4. **Pagination**: Supports pagination using the `since` parameter.
5. **Loading Indicator**: Displays a spinner while loading data.
6. **Notes Indicator**: Displays a note icon if there is note information saved for a user.
7. **Searchable List**: Supports local search by username and notes with precise match and contains criteria.

### Profile
1. **Profile Data**: Fetched from GitHub and displayed with the user's avatar as a header.
2. **Notes**: Supports retrieving and saving notes to the database.
3. **SwiftUI**: Profile section is implemented using SwiftUI.

## How to Run
1. Ensure you have the latest version of Xcode installed.
2. Clone the repository from the provided link.
3. Open the project in Xcode.
4. Build and run the app on a simulator or real device.

## Bonus Features
1. **Result Types**: Utilizes Result types for data fetching.
2. **Dark Mode Support**: Fully supports dark mode.
