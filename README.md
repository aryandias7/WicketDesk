# WicketBase - Cricket Tournament Database

WicketBase is a full-stack web application built with Python (Flask) and MySQL to manage and display data for a cricket tournament. It features a modern, responsive public-facing website for users to browse players, teams, and matches, alongside a secure and dynamic admin panel for complete CRUD (Create, Read, Update, Delete) functionality.

## Features

### Public-Facing Website
- **Modern UI/UX:** A visually appealing and interactive interface with a "serious but colorful" theme.
- **Dynamic Content Sections:** The homepage features animated cards for Featured Players, Teams, Matches, and Venues.
- **Responsive Design:** The layout is designed to work seamlessly on different screen sizes.
- **Detailed Pages:** Users can click on any entity to navigate to a dedicated page with more details.

### Admin Dashboard
- **Secure Login:** The admin panel is protected by a username/password login page with a modern, animated UI.
- **Single Page Application (SPA):** The dashboard is a fluid, dynamic interface that updates content without requiring page reloads, providing a smooth user experience.
- **Full CRUD Functionality:** Administrators can create, read, update, and delete records for all major entities:
    - Players
    - Teams
    - Coaches
    - Matches
    - Umpires
- **Interactive Modals:** All forms for adding and editing data are presented in clean, pop-up modals.
- **Real-Time Feedback:** Actions are confirmed with non-intrusive toast notifications (e.g., "Player added successfully").

## Screenshots


| Login Page | Homepage | Admin Dashboard |
| :---: | :---: | :---: |
| ![Login Page](path/to/LoginPage.png) | ![Homepage](path/to/Homepage.png) | ![Admin Dashboard](path/to/AdminDashboard.png) |

## Tech Stack

- **Backend:** Python 3, Flask
- **Database:** MySQL
- **Frontend:** HTML5, CSS3 (Flexbox, Grid, Animations), JavaScript (ES6+, Fetch API)
- **Python Libraries:** `Flask`, `mysql-connector-python`

## Setup and Installation

Follow these steps to get the project running on your local machine.

### 1. Prerequisites

- **Python 3.x:** Make sure Python is installed on your system.
- **MySQL Server:** The application requires a running MySQL server instance.

### 2. Project Setup

1.  **Download or Clone:** Download the project files and place them in a directory, or clone the repository if it's on Git.

2.  **Database Configuration:**
    * Log into your MySQL server (e.g., via MySQL Workbench or command line).
    * Create the database:
        ```sql
        CREATE DATABASE CT_DBS;
        ```
    * Select the database:
        ```sql
        USE CT_DBS;
        ```
    * Import the provided `CT_DBS.sql` file. This will create all the necessary tables and populate them with initial data.
    * **Crucially, open the `app.py` file** and update the database connection credentials to match your MySQL setup:
        ```python
        mydb = mysql.connector.connect(
            host="localhost",
            user="your_mysql_user",      
            password="your_mysql_password",  
            database="CT_DBS"
        )
        ```

3.  **Create a `requirements.txt` file:**
    * In the root directory of the project, create a new file named `requirements.txt`.
    * Add the following lines to it:
        ```
        Flask
        mysql-connector-python
        ```

4.  **Python Virtual Environment:**
    * Open a terminal in the project's root directory.
    * Create a virtual environment:
        ```bash
        python -m venv venv
        ```
    * Activate the environment:
        * On Windows: `venv\Scripts\activate`
        * On macOS/Linux: `source venv/bin/activate`
    * Install the required packages:
        ```bash
        pip install -r requirements.txt
        ```

## Running the Application

1.  Make sure your MySQL server is running.
2.  With your virtual environment activated, run the Flask application from the root directory:
    ```bash
    python app.py
    ```
3.  The application will be running at: `http://127.0.0.1:3230`

## Usage

- **Public Site:** Open your browser and navigate to `http://127.0.0.1:3230`.
- **Admin Panel:** Navigate to `http://127.0.0.1:3230/login`.
    - **Default credentials** (from `CT_DBS.sql`):
        - **Username:** `user1`
        - **Password:** `user1password`