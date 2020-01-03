# profile_metadata

![](https://img.shields.io/puppetforge/pdk-version/ploperations/profile_metadata.svg?style=popout)
![](https://img.shields.io/puppetforge/v/ploperations/profile_metadata.svg?style=popout)
![](https://img.shields.io/puppetforge/dt/ploperations/profile_metadata.svg?style=popout)
[![Build Status](https://travis-ci.org/ploperations/ploperations-profile_metadata.svg?branch=master)](https://travis-ci.com/ploperations/ploperations-profile_metadata)

- [Description](#description)
- [Usage](#usage)
- [Reference](#reference)
- [Changelog](#changelog)
- [Development](#development)

## Description

profile_metadata allows you to define information about a service within the profile that configures it. The information resulting from all the services included in a role are combined and presented as a structured fact on the host. The service's title and what profile it came from are also added the the message of the day (MOTD).

This module is used extensively inside Puppet to provide information directly on each host and to put data into PuppetDB that is then consumed by other services.

## Usage

This module provides a defined type named `profile_metadata::service` that you can include like any other resource in each profile.

## Reference

This module is documented via `pdk bundle exec puppet strings generate --format markdown`. Please see [Reference](https://forge.puppet.com/ploperations/profile_metadata/reference) on the Puppet Forge or [REFERENCE.md](REFERENCE.md) on GitHub for more info.

## Changelog

[CHANGELOG.md](CHANGELOG.md) is generated prior to each release via `pdk bundle exec rake changelog`. This process relies on labels that are applied to each pull request.

## Development

Pull requests are welcome!
