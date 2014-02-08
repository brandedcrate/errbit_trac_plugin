require 'trac4r'

module ErrbitTracPlugin
  class IssueTracker < ErrbitPlugin::IssueTracker

    LABEL = 'trac'

    FIELDS = [
      [:base_url, {
        :label => 'Trac Project URL (without /xmlrpc)',
        :placeholder => 'http://www.example.com/trac/project'
      }],
      [:username, {
        :label => 'Trac User',
        :placeholder => 'johndoe'
      }],
      [:password, {
        :label => 'Trac Password',
        :placeholder => 'p@assW0rd'
      }],
      [:issue_kind, {
        :label => 'Type of issue to create',
        :placeholder => 'defect'
      }],
    ]

    NOTE = 'This issue tracker integrates with ' \
      '<a href="http://trac.edgewall.org/">trac</a> through the ' \
      '<a href="http://trac-hacks.org/wiki/XmlRpcPlugin">XmlRpcPlugin</a>. ' \
      'Fill in the form below with a URL to your trac project, and account ' \
      'credentials for a user with the XML_RPC permision.'

    def label
      LABEL
    end

    def fields
      FIELDS
    end

    def url
      params["base_url"]
    end

    def configured?
      true
    end

    def note
      NOTE
    end

    def check_params
      if fields.detect { |f| self[f[0]].blank? && !f[1][:optional] }
        errors.add :base, 'You must specify all values!'
      end
    end

    def comments_allowed?
      false
    end

    # @param problem Problem
    def create_issue(problem, reported_by = nil)
      if reported_by
        reporter = reported_by.name
      else
        reporter = "errbit"
      end

      client = Trac.new(params['base_url'], params['username'], params['password'])

      ticket_id = client.tickets.create(issue_title(problem),
                                        body_template.result(binding), {
        :type => params['issue_kind'],
        :reporter => reporter,
        :keywords => "errbit",
      })

      problem.update_attributes(
        :issue_link => link_for_issue(ticket_id),
        :issue_type => label
      )
    end

    def link_for_issue(ticket_id)
      # if it ends in /, remove the /
      if matches = /(.*)\/$/.match(params['base_url'])
        url = matches[1]
      else
        url = params['base_url']
      end

      "%s/ticket/%s" % [url, ticket_id]
    end

    def body_template
      @@body_template ||= ERB.new(File.read(
        File.join(ErrbitTracPlugin.root, 'views', 'trac_body.txt.erb')))
    end
  end
end
