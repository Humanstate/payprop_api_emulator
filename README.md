# PayProp API Emulator

The PayProp API Emulator is available as a stand alone perl script that will allow you to test your client code without having to connect to a remote server. It is written to emulate responses from the latest OpenAPI spec as available on the live PayProp site so will be guaranteed to always return representative data *structures*. Note that all data contained within responses is random, and will not be the same across runs or calls, so whilst the *structures* are representative the data is *not*.

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
  "arrears": 332.1,
  "currency": "}hu*n!g*?CJ1",
  "expenses": 240,
  "from_date": "}}~P4/[kxF>tz2>4Wg",
  "income": 759.4,
  "items": [
    {
      "arrears": 583.2,
      "expenses": 51.4,
      "income": 927.6,
      "property_address": {
        "city": "-_np9x~*^?@G8yhkcVM&7]Cl|0T!NTVV{\\}5g4xLjw",
        "country_code": "zXd7(PpnXG9\"HTV?6U-{52",
        "created": "6RF+(~7itTyg2iundox\\Y_0b!",
        "email": "j$1(z(D}hP.Kg5V*yfOTFgD(%j+*+6X@c]H)wQZ&[Ut",
        "fax": "N3IW`=,dGwL?@~30uWt7A2'5!%{_",
        "first_line": "}xr0H;R|v5LP",
        "id": "p&51YPgEE(",
        "latitude": 178.1,
        "longitude": 547.1,
        "modified": "-jvQ{k-kag`,r#92)`>$\"OM~p?Rbxq38hp.c",
        "phone": ",o8n)b5T[\"SshgRH8X-~j];,h@7",
        "second_line": "0:YBW#c.UT",
        "state": "0dPu!]vQJt`8x\"Gk`=5Nz|.x>F{Lja=wQL+L(hV7VDT!$M",
        "third_line": "vH]hcx%_;#f`K{Gg",
        "zip_code": "z);S9-&_s!|9Af<HgrUW"
      },
      "property_name": "CBmu++f7)HLbDx2/"
    }
  ],
  "to_date": "KZD[#Iri<_vgDlK3,QD[MY"
}
```
