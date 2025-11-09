# 🌟 Hotspot Assignment

A Flutter application built as part of the **Hotspot Assignment Project**.  
This app enables users to explore, select, and describe the kind of hotspots they want to host.  
It emphasizes elegant UI design, responsiveness, and state management using **Riverpod**.

---

## 🚀 Features Implemented

✅ Fetches hotspot experience data from an API using **Dio** with **Riverpod (StateNotifierProvider)**  
✅ Displays a **horizontal scrollable list** of experience cards with images and titles  
✅ Allows users to **select multiple experiences** with real-time visual feedback  
✅ Provides a **TextField** for users to describe their perfect hotspot  
✅ Includes a **“Next” button** that navigates to the next screen, passing selected data  
✅ Handles **loading**, **empty**, and **error states** gracefully  
✅ Uses **SafeArea**, **MediaQuery**, and proper **padding** for consistent layout  
✅ Implements a **dark, modern theme** across all screens  

---

## 🍫 Brownie Points (Optional Enhancements)

⭐ **State Management:** Used **Riverpod** for clean, reactive state management  
⭐ **API Handling:** Integrated **Dio** for efficient and maintainable API requests  
⭐ **Animations:**  
   - Smooth **card selection animation** — selected card slides/animates to the front  
   - “Next” button animation when other UI elements (like record buttons) disappear  
⭐ **Pixel-Perfect UI:** Fonts, colors, and spacing closely follow the Figma design  
⭐ **Responsive Design:** Handled keyboard appearance and reduced viewport height gracefully  
⭐ **Code Architecture:** Clear separation between **model**, **controller**, and **UI layers**  

---

## ✨ Additional Enhancements

- Added **fallback/placeholder image** when network images fail  
- Used **TextEditingController** for text input handling  
- Enhanced **card layout** with modern design and subtle elevation  
- Fully **responsive UI** tested on multiple device sizes  
- Improved **readability** and **code organization** for long-term maintenance  

---

## 🛠️ Tech Stack

| Component | Technology |
|------------|-------------|
| Framework | Flutter |
| Language | Dart |
| State Management | Riverpod |
| Networking | Dio |
| Architecture | MVC (Model–View–Controller) |
| UI Design | Material 3 + Custom Theming |
