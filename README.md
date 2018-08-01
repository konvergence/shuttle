# shuttle
Shuttle Docker project

## Docker example with scientific linux


##  Shuttle 4.9.0 released August 2018

### What's new

#### General
        SAML :
            Multi-Provider Support SAML Multiple Identity Providers (IdP) are supported. Users are prompted to make their choice before authenticating.
        Server Performance : 
            The performance of operations (creating, updating, and deleting values) on cell texts and comments has been improved.
            The performance of the Clean Texts and Comments task has been highly optimized. Based on the usage frequency of texts or comments, it is recommended to run this task on a weekly or daily schedule.
            Various performance improvements have been made on cubes with large amounts of data or text: processing, transaction and caching have been optimized for large volumes of data or text.

        Auditing :
            User auditing on successful logging now explicitly lists all repositories the user can access along with the corresponding authentication source. This allows tracking precisely who has access to what on a session basis.

#### Shuttle Studio
            Improved performance of datamart and repository operations.
            The performance of clear and delete operations has been improved. The operations are highly optimized to handle large volumes of data and text.

#### Shuttle Client
        Improved management of authentication credentials (outside of Shuttle credentials).
        Users are always prompted to enter Proxy authentication credentials which are persistent as part of connection parameters if the 'Use proxy credentials' option is set.
        Users are always prompted to enter Server authentication credentials which are stored in cache if user selects the Remember me option.
        Users can use the Clear Cache option to flush cached credentials.
        Improved sharing of connections, applications, and tabs In addition to sharing
        links to tabs via the clipboard or email, users can now share links to applications.
        Users can now also share connections to Shuttle servers via the clipboard or email. This can be used to distribute new connections to users.
        New connections are automatically added to the list of connections or updated. Clearing the cache doesn't clear the connection.
       Improved caching of images on cells with value types with images



## Shuttle 4.8.1 released at April 2018

### What's New ?

#### General
- Improved performance when processing large volumes of data.
- Added support for SAML HTTP-Redirect binding mode.
#### Shuttle Client
- Improved Login menu behavior when working with multiple connections.
- Better support for configuration with multiple servers using SAML authentication

## Shuttle 4.8.0 released at 23 March 2018

- What's new

  General
    - Rebranding and UI improvements
    - New kShuttle logo, icons, and branding elements.
    - Redesigned and optimized installer screen flow.
    - Multiple UI and usability improvements.
    - Enhanced support of Cloud Operations and Administration
    - New superuser user with full privileges to administrate server and users.
    - Improved security of default admin supervisor.
    - Improved authentication logic to fully support multiple authentication sources (embedded and/or LDAP).
    - Improved Life Cycle management
    - More reliable and secure repository life-cycle during create, clear, delete operations.
    - Advanced repository meta-data to control backup and restore operations.
    - Authentication sources life cycle now decoupled from repository’s.
    - Robust security and seamless client deployment
    - More advanced encryption capability to comply with ANSSI and NIST standards.
    - Simplified proxy management with unified configuration.

  Shuttle Studio
    - Improved UI and usability.
    - Repository listing and operations
    - User listing and operations

  Shuttle Client
    - Brand new 64-bit version (in addition to 32-bit) to leverage full capabilities of 64-bit OS.
    - Simplified proxy management with unified configuration.
    - Improved support for system proxy configuration.

  Platform Policy
  - Full support of both 32-bit and 64-bit OS for Shuttle clients.
  - New support of Microsoft Windows 8.1 for Shuttle clients.
  - New support of Microsoft Windows Server 2016 for Shuttle Server
  - New support of Microsoft SQLServer 2016 for Shuttle datastore.
  

## Shuttle 4.7.0 released at 13 October 2017

### What's New ?

#### General

- Single-Sign On is now available with support of SAML v2 standard.
- Dropdown list on text cells: a text cell can be associated with a list of choices defined as a member list (enabling scripting). This option enables to guide users for their textual data input. The input can be limited to the choice list.
- Ability to export a report as a PowerPoint presentation through a script calling an external resource.
Important: You must have an external resource enabling to build PowerPoint presentations.
- Native support of proxy auto-config files (PAC)

#### Shuttle Studio
- Improved treatment of columns/rows addition: spanned cells are automatically increased when impacted by an addition.
#### Shuttle Client
- Possibility to link to Shuttle Client screens through a share button enabling to copy the link or share it via e-mail.
- Improved the focus for comments: on the subject field when creating a comment, on the body field when answering to or editing a comment.
- Improved chart ranges order when values are missing.


