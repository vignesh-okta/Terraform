# Terraform Provider Okta

- [![Build Status](https://travis-ci.org/articulate/terraform-provider-okta.svg?branch=master)](https://travis-ci.org/articulate/terraform-provider-okta)
- Website: https://www.terraform.io
- [![Gitter chat](https://badges.gitter.im/hashicorp-terraform/Lobby.png)](https://gitter.im/hashicorp-terraform/Lobby)
- Mailing list: [Google Groups](http://groups.google.com/group/terraform-tool)

<img src="https://cdn.rawgit.com/hashicorp/terraform-website/master/content/source/assets/images/logo-hashicorp.svg" width="600px">

## Maintainers

This provider plugin is maintained by the Terraform team at [Articulate](https://articulate.com/). [To contribute see here.](./CONTRIBUTING.md) [For more information on how to develop see here.](./DEVELOPMENT.md) Acceptance tests are no longer run by Travis due to the number of API calls it generates. You must post a passing ACC test screenshot with your PR.

## Requirements

- [Terraform](https://www.terraform.io/downloads.html) 0.12.x
- [Go](https://golang.org/doc/install) 1.12 (to build the provider plugin)

## Demo

For a more in depth holistic usage demo, [see our demo repository here](https://github.com/articulate/terraform-provider-okta-demos).

## Usage

This plugin requires two inputs to run: the okta organization name and the okta api token. The okta base url is not required and will default to "okta.com" if left out.

You can specify the inputs in your tf plan:

```
provider "okta" {
  org_name  = <okta instance name, e.g. dev-XXXXXX>
  api_token = <okta instance api token with the Administrator role>
  base_url  = <okta base url, e.g. oktapreview.com>

  // Optional settings, https://en.wikipedia.org/wiki/Exponential_backoff
  max_retries      = <number of retries on api calls, default: 5>
  backoff          = <enable exponential backoff strategy for rate limits, default = true>
  min_wait_seconds = <min number of seconds to wait on backoff, default: 30>
  max_wait_seconds = <max number of seconds to wait on backoff, default: 300>
}
```

OR you can specify environment variables:

```
OKTA_ORG_NAME=<okta instance name, e.g. dev-XXXXXX>
OKTA_API_TOKEN=<okta instance api token with the Administrator role>
OKTA_BASE_URL=<okta base url, e.g. oktapreview.com>
```

## Examples

As we build out resources we build concomitant acceptance tests that require use to create resource config that actually creates and modifies real resources. We decided to put these test fixtures to good use and provide them [as examples here.](./examples)

## Building The Provider

Clone repository to: `$GOPATH/src/github.com/articulate/terraform-provider-okta`

```sh
$ mkdir -p $GOPATH/src/github.com/articulate; cd $GOPATH/src/github.com/articulate
$ git clone git@github.com:articulate/terraform-provider-okta
```

Enter the provider directory and build the provider. Ensure you have Go Modules enabled, depending on the version of Go you are using, you may have to flip it on with `GO111MODULE=on`.

```sh
$ cd $GOPATH/src/github.com/articulate/terraform-provider-okta
$ make build
```

## Using the provider

Example terraform plan:

```
provider "okta" {
  org_name  = "dev-XXXXX"
  api_token = "XXXXXXXXXXXXXXXXXXXXXXXX"
  base_url  = "oktapreview.com"
}

resource "okta_user" "blah" {
  first_name = "blah"
  last_name  = "blergh"
  email      = "XXXXX@XXXXXXXX.XXX"
  login      = "XXXXX@XXXXXXXX.XXX"
}
```

## Disclaimer

There are particular resources and settings that are not exposed on Okta's public API. Please submit an issue if you find one not listed here.

### Org Settings

- Org level customization settings.

### Predefined SAML Applications

- API Integrations on predefined SAML SSO applications. An example of this is the AWS SSO app, you can configure all of the app settings but you cannot configure anything under Provisioning -> API Integration. According to Okta adding API support for this is not likely.
- Group profile settings on SAML applications. An example of this is the AWS SSO application group assignment which allows you to configure SAML user roles, for instance, which group gets access to which AWS environment. This is exposed on the GET endpoint of the Application Groups API but is read-only at the moment.

## Common Errors

* App User Error
```
The API returned an error: Deactivate application for user forbidden. Causes: errorSummary: The application cannot be unassigned from the user while their group memberships grant them access, The API returned an error: Deactivate application for user forbidden.. Causes: errorSummary: The application cannot be unassigned from the user while their group memberships grant them access.
```

This requires manual intervention. A user's access must be "converted" via the UI to group access. Okta does not expose an endpoint for this.

## Developing the Provider

If you wish to work on the provider, you'll first need [Go](http://www.golang.org) installed on your machine (version 1.8+ is *required*). You'll also need to correctly setup a [GOPATH](http://golang.org/doc/code.html#GOPATH), as well as adding `$GOPATH/bin` to your `$PATH`.

To compile the provider, run `make build`. This will build the provider and put the provider binary in the `$GOPATH/bin` directory.

```sh
$ make build
...
$ $GOPATH/bin/terraform-provider-okta
...
```

In order to test the provider, you can simply run `make test`. The acceptance tests require an API token and a corresponding Okta org, if you use dotenv, you can `cp .env.sample .env` and add your Okta settings there, and prefix make test with `dotenv`.

```sh
$ make test
```

In order to run the full suite of Acceptance tests, run `make testacc`.

*Note:* Acceptance tests create real resources, and often cost money to run.

```sh
$ make testacc
```

### Best Practices

We are striving to build a provider that is easily consumable and eventually can pass the HashiCorp community audit. In order to achieve this end we must ensure we are following HashiCorp's best practices. This can be derived either from their [documentation on the matter](https://www.terraform.io/docs/extend/best-practices/detecting-drift.html), or by using a simple well written [example as our template](https://github.com/terraform-providers/terraform-provider-datadog).
