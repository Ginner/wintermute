{ config, pkgs, lib, ... }:

let
  cfg = config.myHomeModules.tuiPrograms.neomutt;
in
{
  options.myHomeModules.tuiPrograms.neomutt = {
    enable = lib.mkEnableOption "neomutt TUI mail app";
    
    mailsyncCommand = lib.mkOption {
      type = lib.types.str;
      default = "mbsync -a";
      description = "Command to sync all mail";
    };
    
    enableKhard = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable khard integration for contacts";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # Mail clients are managed by accounts.email
      # neomutt, isync (mbsync), msmtp, notmuch are auto-installed
      gnupg
      lynx
      urlscan
      w3m
    ] ++ lib.optional config.myHomeModules.cliPrograms.rbw.enable pkgs.rbw;
    
    programs.neomutt = {
      enable = true;
      vimKeys = true;
      sidebar = {
        enable = true;
        shortPath = true;
        width = 28;
        visible = true;
        format = "%D%* %?F? %F? %?N?%N/?%?S?%S?";
      };
      settings = {
        nobeep = true;
        allow_ansi = true;
        status_chars = " ";
        date_format = "%Y.%m.%d %H:%M";
        index_format = "%3C %Z %?X?& ? %D %-20.20F %s";
        sidebar_divider_char = " | ";   # Character used as divider between sidebar and panels
        sidebar_indent_string = "  ";   # Indent mailboxes this amount
        sidebar_next_new_wrap = "yes" ;    # Should search wrap around when it reaches the end of the list?
        sidebar_sort_method = "unsorted";    # ['unsorted'] Method for sorting the mailboxes
        markers = false;
        
        # Migrated from extraConfig
        use_threads = "threads";
        sort = "reverse-last-date";
        sort_aux = "reverse-last-date";
        uncollapse_jump = true;
        sort_re = true;
        charset = "utf-8";
        send_charset = "utf-8:iso-8859-1:us-ascii";
        pager_index_lines = 15;
        pager_context = 3;
        pager_stop = true;
        menu_scroll = true;
        tilde = true;
        abort_key = "<Esc>";
        mail_check_stats = true;
      };
      binds = [
        { action = "noop"; key = "\\Ck"; map = [ "index" "pager" ]; }
        { action = "noop"; key = "\\Cj"; map = [ "index" "pager" ]; }
        { action = "noop"; key = "\\Co"; map = [ "index" "pager" ]; }
        { action = "recall-message"; key = "P"; map = [ "index" "pager" ]; }
        { action = "group-reply"; key = "R"; map = [ "index" "pager" ]; }
        { action = "bottom"; key = "G"; map = [ "pager" ]; }
        { action = "top"; key = "gg"; map = [ "pager" ]; }
        { action = "last-entry"; key = "G"; map = [ "attach" "browser" "index" ]; }
        { action = "first-entry"; key = "gg"; map = [ "attach" "browser" "index" ]; }
        { action = "complete-query"; key = "<tab>"; map = [ "editor" ]; }

      ];
      macros = [
        { action = "<sidebar-prev><sidebar-open>"; key = "\\Ck"; map = [ "index" "pager" ]; }
        { action = "<sidebar-next><sidebar-open>"; key = "\\Cj"; map = [ "index" "pager" ]; }
        { action = "<enter-command>set pipe_decode = yes<enter><pipe-message>urlscan<enter><enter-command>set pipe_decode = no<enter>"; key = "U"; map = [ "index" "pager" ]; } # View URLs
      ];

      extraConfig = ''
        #
        # Statusbar, date format, finding stuff etc.
        # set status_chars = " "               # Mailbox status symbols, called with '%r'. 'mailbox is unchanged', 'mailbox has changed and needs to be synced', 'mailbox is read-only', 'attach message mode'
        set to_chars = " "        # 'not adressed to your address', 'you are the only recipient', 'multiple recipient', 'you are cc', 'sent by you', 'mailing list', 'address in reply-to'
        set crypt_chars = " "       # Encryption status symbols, 'signed and verified', 'pgp encrypted', 'signed', 'contains public key', 'no crypto info'
        set flag_chars = " "  # 'tagged', 'important', 'flagged for deletion', 'attachment flagged for deletion', 'replied to', 'old - unread but seen', 'new mail', 'old thread', 'new tread', 'the mail is read'(%S), 'the mail is read' (%Z)
        set status_format = "%*-  %D%r  %m messages%?n? (%n new)?%?d? (%d to delete)?%?t? (%t tagged)?  %?p?(  ---  %p postponed  )?%*-"

        # Allow showing longer attachment file-names (180)
        set attach_format = "%u%D%I %t%4n %T%.180d%> [%.7m/%.10M, %.6e%?C?, %C?, %s] "

        # Additional sidebar settings (see whether programs.neomutt.settings works)
        # set sidebar_divider_char = " | "    # Character used as divider between sidebar and panels
        # set sidebar_indent_string = '  '    # Indent mailboxes this amount
        # set sidebar_sort_method = 'unsorted'    # ['unsorted'] Method for sorting the mailboxes
        
        # color sidebar_divider brightwhite default
        # color sidebar_flagged default default
        # color status brightwhite default

        bind index,pager,browser d noop
        bind index,pager,browser \Cd half-down
        bind index,pager,browser \Cu half-up
        bind pager,index dd delete-message
        bind pager,index u undelete-message
        
        auto_view text/html
        alternative_order text/plain text/enriched text/html
        
        # the programs.neomutt.macros/binds unfortunately doesn't allow for descriptions/helptex. I'll keep most here for now
        macro attach s "<save-entry><bol>$HOME/Downloads/<eol>" "Save to Downloads folder"
        
        # Khard integration for contacts
        ${lib.optionalString cfg.enableKhard ''
          set query_command = "khard email --parsable '%s'"
          macro index,pager a "<pipe-message>khard add-email<return>" "add sender to khard contacts"
        ''}

        # Account switching macros - dynamically generated from accounts.email
        ${let
          accounts = config.accounts.email.accounts;
          # Map account names to macro keys and display names
          accountMacros = {
            "work" = { key = "1"; name = "Work"; };
            "private" = { key = "2"; name = "Private"; };
          };
        in lib.concatStringsSep "\n" (lib.mapAttrsToList (accountName: macro:
          let
            account = accounts.${accountName} or null;
          in lib.optionalString (account != null) ''
            macro index,pager i${macro.key} '<sync-mailbox><enter-command>source ${config.xdg.configHome}/neomutt/${accountName}<enter><change-folder>!<enter>;<check-stats>' "switch to ${macro.name}"
          ''
        ) accountMacros)}

        # Source primary account at startup
        ${let
          primaryAccountName = lib.findFirst 
            (name: config.accounts.email.accounts.${name}.primary or false) 
            null 
            (lib.attrNames config.accounts.email.accounts);
        in lib.optionalString (primaryAccountName != null) ''
          source ${config.xdg.configHome}/neomutt/${primaryAccountName}
        ''}

        ### From mutt-wizard:
        set mime_type_query_command = "file --mime-type -b %s"
set smtp_authenticators = 'gssapi:login'
set rfc2047_parameters = yes
set sleep_time = 0		# Pause 0 seconds for informational messages
set mark_old = no		# Unread mail stay unread until read
set mime_forward = no	# mail body is forwarded as text
set forward_attachments = yes	# attachments are forwarded with mail
set wait_key = no		# mutt won't ask "press key to continue"
set fast_reply			# skip to compose when replying
set fcc_attach			# save attachments with the body
set forward_format = "Fwd: %s"	# format of subject when forwarding
set forward_quote		# include message in forwards
set reverse_name		# reply as whomever it was to
set include			# include message in replies
auto_view application/pgp-encrypted

bind index,pager i noop
bind index,pager g noop
bind index \Cf noop
bind index,pager M noop
bind index,pager C noop
bind editor <space> noop
bind index h noop

# General rebindings
bind index j next-entry
bind index k previous-entry
bind attach <return> view-mailcap
bind attach l view-mailcap
bind pager,attach h exit
bind pager j next-line
bind pager k previous-line
bind pager l view-attachments
bind index L limit
bind index l display-message
bind index,query <space> tag-entry
macro browser h '<change-dir><kill-line>..<enter>' "Go to parent folder"
bind index,pager H view-raw-message
bind browser l select-entry
bind index,pager S sync-mailbox
bind index \031 previous-undeleted	# Mouse wheel
bind index \005 next-undeleted		# Mouse wheel
bind pager \031 previous-line		# Mouse wheel
bind pager \005 next-line		# Mouse wheel

macro index,pager gi "<change-folder>=INBOX<enter>" "go to inbox"
macro index,pager Mi ";<save-message>=INBOX<enter>" "move mail to inbox"
macro index,pager Ci ";<copy-message>=INBOX<enter>" "copy mail to inbox"
macro index,pager gd "<change-folder>=Drafts<enter>" "go to drafts"
macro index,pager Md ";<save-message>=Drafts<enter>" "move mail to drafts"
macro index,pager Cd ";<copy-message>=Drafts<enter>" "copy mail to drafts"
macro index,pager gj "<change-folder>=Junk<enter>" "go to junk"
macro index,pager Mj ";<save-message>=Junk<enter>" "move mail to junk"
macro index,pager Cj ";<copy-message>=Junk<enter>" "copy mail to junk"
macro index,pager gt "<change-folder>=Trash<enter>" "go to trash"
macro index,pager Mt ";<save-message>=Trash<enter>" "move mail to trash"
macro index,pager Ct ";<copy-message>=Trash<enter>" "copy mail to trash"
macro index,pager gs "<change-folder>=Sent<enter>" "go to sent"
macro index,pager Ms ";<save-message>=Sent<enter>" "move mail to sent"
macro index,pager Cs ";<copy-message>=Sent<enter>" "copy mail to sent"
macro index,pager ga "<change-folder>=Archive<enter>" "go to archive"
macro index,pager Ma ";<save-message>=Archive<enter>" "move mail to archive"
macro index,pager Ca ";<copy-message>=Archive<enter>" "copy mail to archive"

macro index O "<shell-escape>${cfg.mailsyncCommand}<enter>" "run mailsync to sync all mail"
macro index \Cf "<enter-command>unset wait_key<enter><shell-escape>printf 'Enter a search term to find with notmuch: '; read x; echo \$x >\"\${XDG_CACHE_HOME:-\$HOME/.cache}/mutt_terms\"<enter><limit>~i \"\`notmuch search --output=messages \$(cat \"\${XDG_CACHE_HOME:-\$HOME/.cache}/mutt_terms\") | head -n 600 | perl -le '@a=<>;s/\^id:// for@a;$,=\"|\";print@a' | perl -le '@a=<>; chomp@a; s/\\+/\\\\+/g for@a; s/\\$/\\\\\\$/g for@a;print@a' \`\"<enter>" "show only messages matching a notmuch pattern"
macro index A "<limit>all\n" "show all messages (undo limit)"


# I've removed all the mutt-wizard color stuff, in the hopes, that stylix can handle it...
      '';

      extraFiles."mailcap".text = ''
        text/html; ${pkgs.lynx}/bin/lynx -dump -width=120 -stdin; nametemplate=%s.html; copiousoutput
        text/html; ${pkgs.w3m}/bin/w3m -dump -cols 120 -T text/html -I %{charset} -O utf-8; copiousoutput
      '';
    };
  };
}
