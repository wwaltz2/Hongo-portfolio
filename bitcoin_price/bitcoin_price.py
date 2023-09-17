import requests
import sys

def main():
    if len(sys.argv) != 2:
        sys.exit('Missing command-line argument')

    amount = float(sys.argv[1])
    url = 'https://api.coindesk.com/v1/bpi/currentprice.json'

    try:
        r = requests.get(url)
        data = r.json()
        price = float(data['bpi']['USD']['rate_float'])
        price_f = price * amount
        print("Price of", amount, "bitcoin: ", f'${price_f:,.4f}')
        sys.exit()
    except requests.RequestException:
        sys.exit()

main()