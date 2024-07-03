import sqlite3
import sys

def delete_data_and_vacuum(db_name):
    try:
        # Connect to SQLite database
        conn = sqlite3.connect(db_name)
        cursor = conn.cursor()

        # SQL query to delete all data from the table
        cursor.execute("DROP TABLE IF EXISTS messages")

        # VACUUM command to reduce the database file size
        cursor.execute("VACUUM")

        # Commit changes and close the connection
        conn.commit()
        print("All data from 'messages' deleted and database vacuumed successfully.")

    except sqlite3.Error as e:
        print(f"SQLite error: {e}")
    finally:
        if conn:
            conn.close()

if __name__ == "__main__":
    # Provide your SQLite database file name here
    db_name = ""
    for i, arg in enumerate(sys.argv):
        if(i == 1):
            db_name = arg
    delete_data_and_vacuum(db_name)
