#!/bin/bash


# Function to create a new project
create_project() {
    read -p "Enter your project name: " PROJECT_NAME

    if [ -z "$PROJECT_NAME" ]; then
        echo "Project name cannot be empty. Exiting."
        return 1
    fi


    mkdir "$PROJECT_NAME"
    cd "$PROJECT_NAME" || return 1
    mkdir header src assets lib scripts

    # Create .gitignore, README, CMakeLists.txt, and other project files
    cat > .gitignore <<EOL
# Ignore build files
/build/

# Ignore CMake cache and temp files
CMakeCache.txt
CMakeFiles/
Makefile
*.cmake
*.swp

# Ignore IDE specific files
.idea/
.vscode/
EOL

    cat > README.md <<EOL
# Provide instructions for building the project
To build the project, follow these steps:
1. Open a terminal.
2. Navigate to the project directory.
3. Run the following commands:
   mkdir build
   cd build
   cmake ..
   make
4. Run the executable:
   ./$PROJECT_NAME
EOL

    cat > CMakeLists.txt <<EOL
cmake_minimum_required(VERSION 3.10)
project(CppFileGenerator VERSION 1.0)

set(CMAKE_C_STANDARD 99)
set(CMAKE_C_STANDARD_REQUIRED True)

# Ensure the compile_commands.json file is generated
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Set output directory within the build directory
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY \${CMAKE_BINARY_DIR}/bin)

if (WIN32)
    message(STATUS "Configuring for Windows...")
    if (MSVC)
        set(CMAKE_GENERATOR_PLATFORM x64)
    else()
        find_program(GCC_BIN g++)
        find_program(CLANG_BIN clang)
        if (GCC_BIN)
            set(CMAKE_C_COMPILER \${GCC_BIN})
        elseif (CLANG_BIN)
            set(CMAKE_C_COMPILER \${CLANG_BIN})
        else()
            message(FATAL_ERROR "Neither MSVC, GCC, nor Clang found! Please install a compiler.")
        endif()
    endif()
elseif (APPLE)
    set(CMAKE_C_COMPILER clang++)
elseif (UNIX)
    find_program(GCC_BIN g++)
    find_program(CLANG_BIN clang)
    if (GCC_BIN)
        set(CMAKE_C_COMPILER \${GCC_BIN})
    elseif (CLANG_BIN)
        set(CMAKE_C_COMPILER \${CLANG_BIN})
    else()
        message(FATAL_ERROR "Neither G++ nor Clang found! Please install a compiler.")
    endif()
endif()

# Locate source files
file(GLOB SOURCES "src/*.cpp")

# Add executable target with source files
add_executable(app \${SOURCES})

# Link header file directory
target_include_directories(app PRIVATE header)

if (MSVC)
    target_compile_options(app PRIVATE /W4 /permissive-)
else()
    target_compile_options(app PRIVATE -Wall -Wextra -Wpedantic)
endif()
EOL

    cat > header/win.h <<EOL
#ifndef WIN_H
#define WIN_H

#include <iostream>

void displayMessage() {
    std::cout << "Hello, World from $PROJECT_NAME!" << std::endl;
}

#endif // WIN_H
EOL

    cat > src/main.cpp <<EOL
#include "win.h"

int main() {
    displayMessage();
    return 0;
}
EOL

    echo "Project '$PROJECT_NAME' created successfully!"

    # Ask if the user wants to initialize a git repository
    read -p "Do you want to initialize a Git repository? (y/n): " INIT_GIT

    if [[ "$INIT_GIT" == "y" || "$INIT_GIT" == "Y" ]]; then
        git init
        git add .
        git commit -m "Initial commit for $PROJECT_NAME"
        echo "Git repository initialized and initial commit made."
    else
        echo "No Git repository initialized."
    fi

    # Create .clangd file for clangd configuration
    cat > .clangd <<EOL
CompileFlags:
  Add:
    - -std=c++17
    - -Wall
    - -Wextra
    - -Wpedantic

# Use compile_commands.json for clangd
CompilationDatabase: ./build/compile_commands.json
EOL

    # Create build.sh script in scripts folder
    cat > scripts/build.sh <<EOL
#!/bin/bash

# Check if the build directory exists, create if not
if [ ! -d "build" ]; then
    echo "Build directory doesn't exist. Creating build directory."
    mkdir build
fi

# Navigate to the build directory and build the project
cd build || exit
cmake ..
make
EOL
    chmod +x scripts/build.sh

    # Create run.sh script in scripts folder
    cat > scripts/run.sh <<EOL
#!/bin/bash
# Check if the build directory exists
if [ ! -d "build" ]; then
    echo "Build directory does not exist. Please build the project first using build.sh."
    exit 1
fi

# Navigate to the build directory and run the executable

cd build
cd bin
./app
EOL
    chmod +x scripts/run.sh

    exit 0
}

# Main loop for handling user actions
while true; do
    # Load theme (no actual theme change, but for structure)
    set_dark_mode

    # Ask for action
    echo "Choose an action:"
    echo "1) Create a project"
    echo "2) Exit"
    read -p "Enter your choice (1 or 2): " ACTION

    # Check the user's action and call the corresponding function
    case $ACTION in
        1)
            create_project
            break  # Exit after project creation
            ;;
        2)
            echo "Exiting the script."
            break  # Exit the script
            ;;
        *)
            echo "Invalid option. Please enter 1 or 2."
            ;;
    esac
done

