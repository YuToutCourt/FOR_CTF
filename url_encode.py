import argparse

val = {':':"%253A",'/':"%252F",'.':"%252E",'-':"%252D",'=':"%253D"}

if __name__ == "__main__":

    parser = argparse.ArgumentParser(description='Encode a URL')
    parser.add_argument('-u', '--url', help='URL to encode')

    args = parser.parse_args()

    url = args.url

    # Translate the URL
    table = url.maketrans(val)
    encoded_url = url.translate(table)

    print("Encoded URL =>", encoded_url)
