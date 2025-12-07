import xml.etree.ElementTree as ET
import psycopg2
from psycopg2 import sql

def main():
    print("Hello from postgresql-megacourse!")

# !!! IMPORTANT: Replace these with your actual PostgreSQL connection details !!!
DB_CONFIG = {
    'host': 'localhost',
    'database': 'bank',
    'user': 'usr',
    'password': '123',
    'port': '5432'
}

# --- Configuration ---
XML_FILE = './own_project/op1.xml'
DB_FILE = 'bank.db'
TABLE_NAME = 'account_operation'


def clean_value(value):
    """
    Removes '+' sign, replaces comma with dot, and converts to float.
    PostgreSQL is strict, so we ensure the format is correct for DECIMAL.
    """
    if value is None:
        return None
    # Remove '+' and replace Polish decimal comma with English decimal point
    cleaned = value.strip().lstrip('+').replace(',', '.')
    try:
        # We return the float; psycopg2 handles conversion to PostgreSQL's DECIMAL/NUMERIC type
        return float(cleaned)
    except ValueError:
        return cleaned


def import_xml_to_postgres():
    conn = None
    try:
        # 1. Connect to the PostgreSQL database
        conn = psycopg2.connect(**DB_CONFIG)
        cursor = conn.cursor()
        print(f"Connected to PostgreSQL database: {DB_CONFIG['database']}")

        # 2. Create the table schema
        # PostgreSQL uses NUMERIC for high-precision decimals
        create_table_command = sql.SQL("""
                                       CREATE TABLE IF NOT EXISTS {}
                                       (
                                           id
                                           SERIAL
                                           PRIMARY
                                           KEY,
                                           order_date
                                           DATE,
                                           execution_date
                                           DATE,
                                           operation_type
                                           VARCHAR
                                       (
                                           100
                                       ),
                                           description TEXT,
                                           amount NUMERIC
                                       (
                                           10,
                                           2
                                       ),
                                           amount_currency CHAR
                                       (
                                           3
                                       ),
                                           ending_balance NUMERIC
                                       (
                                           10,
                                           2
                                       ),
                                           balance_currency CHAR
                                       (
                                           3
                                       )
                                           )
                                       """).format(sql.Identifier(TABLE_NAME))

        cursor.execute(create_table_command)
        conn.commit()
        print(f"Table '{TABLE_NAME}' ensured.")

        # 3. Parse the XML file
        try:
            tree = ET.parse(XML_FILE)
            root = tree.getroot()
        except FileNotFoundError:
            print(f"Error: XML file '{XML_FILE}' not found.")
            return
        except ET.ParseError as e:
            print(f"Error parsing XML: {e}")
            return

        operations_count = 0

        # 4. Iterate through all <operation> elements
        for operation in root.findall('./operations/operation'):
            # Extract data points
            data = {
                'order_date': operation.find('order-date').text,
                'execution_date': operation.find('exec-date').text,
                'operation_type': operation.find('type').text,
                'description': operation.find('description').text,
            }

            # Extract amount and currency
            amount_element = operation.find('amount')
            data['amount'] = clean_value(
                amount_element.text) if amount_element is not None else None
            data['amount_currency'] = amount_element.get(
                'curr') if amount_element is not None else None

            # Extract ending-balance and currency
            balance_element = operation.find('ending-balance')
            data['ending_balance'] = clean_value(
                balance_element.text) if balance_element is not None else None
            data['balance_currency'] = balance_element.get(
                'curr') if balance_element is not None else None

            # 5. Prepare and Execute the SQL INSERT statement

            # Filter out keys with None values if you want strict insertion,
            # but usually it's best to include all defined columns.
            columns = list(data.keys())
            values = [data[col] for col in columns]

            insert_sql = sql.SQL("INSERT INTO {} ({}) VALUES ({})").format(
                sql.Identifier(TABLE_NAME),
                sql.SQL(', ').join(map(sql.Identifier, columns)),
                sql.SQL(', ').join(sql.Placeholder() * len(columns))
            )

            cursor.execute(insert_sql, values)
            operations_count += 1

        # 6. Commit and Close
        conn.commit()
        print(
            f"\n✅ Successfully imported {operations_count} operations into PostgreSQL.")

    except (Exception, psycopg2.Error) as error:
        print("\n❌ Error while connecting to or interacting with PostgreSQL:",
              error)
    finally:
        if conn is not None:
            conn.close()
            print("PostgreSQL connection closed.")


if __name__ == '__main__':
    import_xml_to_postgres()
