# Messenger Platform Sample -- node.js and SWI Prolog

## Setup

Create a [Messenger app](https://developers.facebook.com/) and [page](https://www.facebook.com/pages/create).

If you don't have a Heroku account, [create one](https://signup.heroku.com/signup/dc). Ensure you have the [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli) installed.

Fork this repository, then clone it:

```
git clone https://github.com/.../iart-bot.git

cd iart-bot
```
Get the App ID:

![id](https://cloud.githubusercontent.com/assets/9307236/24323771/c23c7254-1172-11e7-9d1b-1cb7114ff092.JPG)

Paste it in `public/index.html`, in addition to the ID of your page.

Set the values in `config/default.json`:

Get the App Secret from the App Dashboard:

![dash](https://cloud.githubusercontent.com/assets/9307236/24323807/62bc2b98-1173-11e7-9a64-ded167716bd7.JPG)

Select your page and get the Page Access Token:

![pageselect](https://cloud.githubusercontent.com/assets/9307236/24323666/0ab5c9e2-1171-11e7-9385-55263793b134.JPG)

Finally choose any string for the `validationToken`.

Run the following commands to create a Heroku app and deploy the code.

```
heroku create

heroku buildpacks:add heroku/nodejs

heroku buildpacks:add https://github.com/ricardocerq/heroku-prolog-buildpack.git

git add .

git commit -m "set values"

git push heroku master

heroku open
```
A browser window will open with the URL of your Heroku app. Copy it.

In the Webhooks section, click "Setup Webhooks".

In the "Callback URL" paste the URL and add `/webhook` at the end. Under "Verify Token" set the string you choose for the `validationToken`. Under "Subscription Fields", select `messages` and `messaging_postbacks`.

Then select your page.

![page](https://cloud.githubusercontent.com/assets/9307236/24324028/b2386aa8-1176-11e7-9fef-b437b60c661e.JPG)

And click "Subscribe".
 
Go back to your Heroku app and click the "Message us" button and chat away!

Refer to the [Messenger bot tutorial](https://developers.facebook.com/docs/messenger-platform/quickstart) and the [Heroku NodeJS tutorial](https://devcenter.heroku.com/articles/getting-started-with-nodejs#introduction) if you get stuck.

## Changing the bot

Replace the predicate `answer/3` in `prolog/request.pl` to implement the functionality of your bot. To redeploy, push to `heroku/master`.
To add support for more Web API's, add a fact `ws/1` with the atom representing it. Add a fact `ws_info/2` with the information necessary to make an API call (keys, ids, host, path, etc):
```
ws_info(atom, [
  key=<KEY>,
  host=<HOST>,
  path=<PATH>,
]).
```
Then use get_ws_info to get the data in ws_info by passing an association list Key=Value where Key is the parameter to extract and Value is a variable that will contain the value associated with the atom in the ws_info predicate. Then call request/6 with the hostname, the base path to the API, the path parameters to the API (will be separated by "/" in the URL), then the search parameters and finally the headers to add to the request specific to that web service. The result will be a Prolog term representing the JSON object returned by the API.

