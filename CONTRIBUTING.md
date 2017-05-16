# Contributing to Pyload Cookbook

We're glad that you want to contribute to the Pyload cookbook! The first step is the desire to improve the project.

## Submitting Issues

Not every contribution comes in the form of code. Submitting, confirming, and triaging issues is an important task for any project. We use GitHub to track all project issues. All of our cookbooks (among other projects) can be found in our [GitHub organization](https://github.com/gridtec/).

## Contribution Process

We have a 4 step process for contributions:

1. Fork the project
2. Commit changes to a git branch of your fork
3. Create a GitHub Pull Request for your change, following the instructions in the [pull request template](#pull-request-requirements).
4. Perform a [Code Review](#code-review-process) with the cookbook maintainers on the pull request.

### Pull Request Requirements

In general our Chef cookbooks are built to last. We strive to ensure high quality in our projects. In order to ensure this, all pull requests must meet these specifications:

1. **Style:** To allow this project to be compliant to latest Ruby and Chef style guides / best practices, this cookbook runs Rubocop and Foodcritic on every single build. See the TESTING.md file for additional information on checking cookbook style locally, to ensure your CI build is green.
2. **Tests:** To ensure high quality code and protect against future regressions, we require all cookbook code to be tested in some way. This can be either unit testing with ChefSpec and/or integration testing with Test Kitchen / InSpec. See the TESTING.md file for additional information on testing in Chef cookbooks.
3. **Green CI Builds:** We use the [Travis CI](https://travis-ci.org/) system to test all pull requests. We require these test runs to succeed on every pull request before being merged.

### Code Review Process

Code review takes place in GitHub pull requests. See [this article](https://help.github.com/articles/about-pull-requests/) if you're not familiar with GitHub Pull Requests.

Once you open a pull request, cookbook maintainers will review your code using the built-in code review process in Github PRs. The process at this point is as follows:

1. A cookbook maintainer will review your code and merge it if no changes are necessary. Your change will be merged into the cookbooks's `master` branch.
2. If a maintainer has feedback or questions on your changes they will set `request changes` in the review and provide an explanation.

## Using git

You can copy this Chef cookbook repository to your local workstation by running `git clone https://github.com/gridtec/cookbook-pyload.git`.

For collaboration purposes, it is best if you create a GitHub account and *fork* the repository to your own account. Once you do this you will be able to push your changes to your GitHub repository for others to see and use.

### Branches and Commits

You should submit your patch as a git branch named after the Github issue, such as GH-22\. This is called a _topic branch_ and allows users to associate a branch of code with the ticket.

It is a best practice to have your commit message include the ticket number, followed by an empty line and then a brief description of the commit. This also helps other contributors understand the purpose of changes to the code.

Remember that not all users use Chef in the same way or on the same operating systems as you, so it is helpful to be clear about your use case and change so they can understand it even when it doesn't apply to them.

Small changes, such as fixing typos, do not require a ticket to be created. It is enough to fork your project and submit a pull request.

## Release Cycle

The versioning for Chef Software Cookbook projects is X.Y.Z.

- X is a major release, which may not be fully compatible with prior major releases
- Y is a minor release, which adds both new features and bug fixes
- Z is a patch release, which adds just bug fixes

See the [Cookbook Versioning Policy](https://chef-community.github.io/cvp/) for more guidance on semantic versioning of cookbooks.

Releases of Chef's cookbooks are generally performed after any bugfix / feature enhancement pull request merge. You can watch the Github repository for updates or watch the cookbook on the Supermarket to receive release notification e-mails.

## Contribution Do's and Don't's

Please do include tests for your contribution. Not all platforms that a cookbook supports may be supported by Test Kitchen. Please provide evidence of testing your contribution if it isn't trivial so we don't have to duplicate effort in testing.

Please do indicate new platform (families) or platform versions in the commit message, and update the relevant ticket. If a contribution adds new platforms or platform versions, indicate such in the body of the commit message(s), and update the relevant issues.

Please do ensure that your changes do not break or modify behavior for other platforms supported by the cookbook. For example if your changes are for Debian, make sure that they do not break on CentOS.

Please do **not** modify the version number in the `VERSION` file or change the version section of `metadata.rb`, a maintainer will select the appropriate version regarding your change.

Please do **not** modify the following files of this project, which are `chefignore`, `.gitignore` and `LICENSE`.
