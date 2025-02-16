from app import create_app  # Import only after Flask has been fully set up

app = create_app()  # Call the function to initialize the app

if __name__ == "__main__":
    app.run(debug=True)
