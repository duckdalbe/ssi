## Server Side Includes Script

This script will read HTML files and interpolate the server-side include
statements.  This was created so that web sites that are almost completely
static can have their includes processed before being uploaded to a static site
service like [Amazon's S3](http://aws.amazon.com/s3/).

Information about server-side includes can be found at the
[httpd](http://httpd.apache.org/docs/2.2/howto/ssi.html) or
[nginx](http://wiki.nginx.org/HttpSsiModule) website. The only SSI supported at
this time is `include`.

The processing is recursive so please avoid circular includes.

The work was inspired by the [rbssi script](https://github.com/taf2/rbssi).

## Installation

* gem install ssi

## Usage

See the help message for the options:

    # /usr/bin/ssi --help

If the `inplace` option is not specified, the resultant content will be printed
to standard out as a preview. No files are altered in this mode.

We will usually modify the files `inplace`. This will be done like so:

    # /usr/bin/ssi -i 'orig' file1 file2

This will modify `file1` and `file2` after making a backup of each file with
the `.orig` extension. Use the empty string '' if you do not want to make
backups. CAUTION: The `inplace` option will overwrite the original if run
consecutively!

When processing the server-side includes for a many files under the current
directory, I use a combination of `find` and `xargs`:

    # find . -type f -name "*html" -print0 | xargs -0 /usr/bin/ssi -i ''

## To Do

* Tests

## Bugs

* This gem was not thoroughly tested. More testing is in progress.

[Found a bug?](http://github.com/bwong114/ssi/issues)

## Contact

* Mail

  bwong114 [at] gmail.com
