# PayProp API Emulator

The PayProp API Emulator is available as a stand alone perl script that will allow you to test your client code without having to connect to a remote server. It is written to emulate responses from the latest OpenAPI spec as available on the PayProp staging site so will be guaranteed to always return representative data *structures*. Note that all data contained within responses is random, and will not be the same across runs or calls, so whilst the *structures* are representative the data is *not*.

## Setup and running

The emulator is a perl script that requires a couple of CPAN modules

### Install necessary perl modules

Note if you are not using the system perl you shouldn't need to prefix the two commands below with `sudo`.

```
sudo cpan App::cpanminus # if you do not already have cpanm installed
sudo cpanm --installdeps .
```

### Export the environment variables:

```
export PP_API_CLIENT_IDENTIFIER=WhoYouAre
export PP_API_CLIENT_REDIRECT_URI=http://your.redirect.uri/path
export PP_API_JWT_SECRET=SomeJWTSecret
```

### Run the emulator

```
morbo ./payprop_api_emulator.pl -l 'https://*:3001'
```

You can now call https://127.0.0.1:3001 like you would the PayProp API.

## Debugging

To get an access token on the command line:

```
curl -v -k "https://127.0.0.1:3001/oauth/authorize?client_id=$PP_API_CLIENT_IDENTIFIER&response_type=token&redirect_uri=$PP_API_CLIENT_REDIRECT_URI"
```

You should see the JWT access token in the Location header:

```
< Location: http://your.redirect.uri/path?access_token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOm51bGwsImNsaWVudCI6Ildob1lvdUFyZSIsImV4cCI6MTQ4NTM1ODU5MiwiaWF0IjoxNDg1MzU0OTkyLCJqdGkiOiJzUGY3bkFyZ2ZJSnJRR1pnSFgwQllCODYzcmpjTExtTiIsInNjb3BlcyI6W10sInR5cGUiOiJhY2Nlc3MiLCJ1c2VyX2lkIjpudWxsfQ.H1tD1H46XzBeaQ_iSvdks7oCk5NLX_v6ci_mbzQEjks&token_type=bearer&expires_in=3600
```

Copy it into an env variable:

```
export PP_API_TOKEN=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOm51bGwsImNsaWVudCI6Ildob1lvdUFyZSIsImV4cCI6MTQ4NTM1ODU5MiwiaWF0IjoxNDg1MzU0OTkyLCJqdGkiOiJzUGY3bkFyZ2ZJSnJRR1pnSFgwQllCODYzcmpjTExtTiIsInNjb3BlcyI6W10sInR5cGUiOiJhY2Nlc3MiLCJ1c2VyX2lkIjpudWxsfQ.H1tD1H46XzBeaQ_iSvdks7oCk5NLX_v6ci_mbzQEjks
```

Then you can call the emulator:

```
> curl -k -H"Authorization: Bearer $PP_API_TOKEN" -X GET 'https://127.0.0.1:3001/api/v1.0/me/portfolio'
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   804  100   804    0     0  23519      0 --:--:-- --:--:-- --:--:-- 23647
{
  "arrears": 1000.01,
  "currency": "CHF",
  "expenses": 1000.01,
  "from_date": "2000-01-01T00:00:01",
  "income": 1000.01,
  "items": [
    {
      "arrears": 1000.01,
      "expenses": 1000.01,
      "income": 1000.01,
      "property_address": {
        "city": "Villars-sur-Ollon",
        "country_code": "CH",
        "created": "2000-01-01T00:00:00",
        "email": "foo@gmail.com",
        "fax": "020 1234 5678",
        "first_line": "Av. Centrale",
        "id": "D8eJPwZG7j",
        "latitude": "-33.93515325806508",
        "longitude": 18.4195876121522,
        "modified": "2000-01-01T00:00:01",
        "phone": "020 1234 5678",
        "second_line": "%Z1,nea,vtXfjoMZR_{>iZE>",
        "state": "Vaud",
        "third_line": "EcgJBjvmD+>jH3Y8R}>MxW\"I#P(|b*a}Qt/o",
        "zip_code": "1884"
      },
      "property_name": "Magnolia Rd 4"
    }
  ],
  "to_date": "2000-01-01T00:00:01"
}
```
