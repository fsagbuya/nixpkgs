{
  lib,
  stdenv,
  autoreconfHook,
  buildEnv,
  fetchFromGitHub,
  perl,
  perlPackages,
  makeWrapper,
  gnupg,
  openssl,
}:

stdenv.mkDerivation rec {
  pname = "rt";
  version = "6.0.1";

  src = fetchFromGitHub {
    repo = "rt";
    rev = "rt-${version}";
    owner = "bestpractical";
    hash = "sha256-liI+ycSS98YXQOJ+hKz9cMRMotwuO238X7oPT/d5/xs=";
  };

  patches = [
    ./dont-check-users_groups.patch # needed for "make testdeps" to work in the build
    ./override-generated.patch
  ];

  nativeBuildInputs = [
    autoreconfHook
    makeWrapper
  ];

  buildInputs = [
    perl
    (buildEnv {
      name = "rt-perl-deps";
      paths =
        with perlPackages;
        (requiredPerlModules [
          # Core dependencies
          ApacheSession
          BusinessHours
          CGI
          CGIEmulatePSGI
          CGIPSGI
          ClassAccessorFast
          Clone
          ConvertColor
          CryptEksblowfish
          CSSInliner
          CSSMinifierXS
          CSSSquish
          DataGUID
          DataICal
          DataPage
          DateExtract
          DateManip
          DateTime
          DateTimeFormatNatural
          DateTimeLocale
          DBI
          DBIxSearchBuilder
          DBDPg
          DevelGlobalDestruction
          DevelStackTrace
          DigestMD5
          DigestSHA
          EmailAddress
          EmailAddressList
          Encode
          EncodeDetect
          EncodeHanExtra
          FileShareDir
          FileTemp
          HashMerge
          HashMergeExtra
          HTMLFormatExternal
          HTMLFormatTextWithLinks
          HTMLFormatTextWithLinksAndTables
          HTMLGumbo
          HTMLMason
          HTMLMasonPSGIHandler
          HTMLQuoted
          HTMLRewriteAttributes
          HTMLScrubber
          HTTPMessage
          Imager
          IPCRun3
          JavaScriptMinifierXS
          JSON
          ListMoreUtils
          LocaleMaketext
          LocaleMaketextFuzzy
          LocaleMaketextLexicon
          LogDispatch
          LWP
          LWPProtocolHttps
          LWPUserAgent
          MIMETools
          MIMETypes
          MailTools
          ModuleRefresh
          ModuleRuntime
          ModuleVersionsReport
          MozillaCA
          NetCIDR
          NetIP
          ParallelForkManager
          PathDispatcher
          Plack
          Starlet
          RegexpCommon
          RegexpCommonnetCIDR
          RegexpIPv6
          RoleBasic
          ScopeUpper
          Storable
          SymbolGlobalName
          SysSyslog
          TermReadKey
          TextPasswordPronounceable
          TextQuoted
          TextTemplate
          TextWikiFormat
          TextWordDiff
          TextWrapper
          TimeLocal
          TimeHiRes
          TimeParseDate
          TreeSimple
          URI
          XMLRSS

           # Mailgate dependencies
          GetoptLong
          PodUsage
          
          # REST2 dependencies (new in RT 6)
          Moose
          MooseXNonMoose
          MooseXRoleParameterized
          namespaceautoclean
          SubExporter
          WebMachine
          ModulePath

          # Optional Dependencies
          FCGI
          FileWhich
          GnuPGInterface
          PerlIOeol
          CryptX509
          StringShellQuote
          GraphViz2
          IPCRun
          perlldap
        ]);
    })
  ];

  preAutoreconf = ''
    echo rt-${version} > .tag
  '';
  preConfigure = ''
    appendToVar configureFlags "--with-web-user=$UID"
    appendToVar configureFlags "--with-web-group=$(id -g)"
    appendToVar configureFlags "--with-rt-group=$(id -g)"
    appendToVar configureFlags "--with-bin-owner=$UID"
    appendToVar configureFlags "--with-libs-owner=$UID"
    appendToVar configureFlags "--with-libs-group=$(id -g)"
  '';
  configureFlags = [
    "--enable-graphviz"
    "--enable-gpg"
    "--enable-smime"
    "--with-db-type=Pg"
  ];

  buildPhase = ''
    make testdeps
  '';

  postFixup = ''
    for i in $(find $out/bin -type f); do
      wrapProgram $i --prefix PERL5LIB ':' $PERL5LIB \
        --prefix PATH ":" "${
          lib.makeBinPath [
            openssl
            gnupg
          ]
        }"
    done

    rm -r $out/var
    mkdir -p $out/var/data
    ln -s /var/log/rt $out/var/log
    ln -s /run/rt/mason_data $out/var/mason_data
    ln -s /var/lib/rt/shredder $out/var/data/RT-Shredder
    ln -s /var/lib/rt/smime $out/var/data/smime
    ln -s /var/lib/rt/gpg $out/var/data/gpg
  '';

  meta = {
    platforms = lib.platforms.unix;
  };
}
