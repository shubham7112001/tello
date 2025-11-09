class GraphDocument {
  static final String getAllTeams = """
    query UserByUserName {
      me {
        teams {
          id
          name
          boards {
            id
            name
            slug
            key
          }
        }
      }
    }
  """;

  static String boardBySlug(String slug) {
    return """
      query BoardBySlug {
        boardBySlug(slug: "$slug") {
          id
          name
          description
          lists {
            id
            color
            name
            pos
            cards {
              id
              slug
              title
              pos
              card_number
              due_date
              archived_at
              users {
                id
                name
              }
              labels {
                id
                name
                color
              }
            }
          }
        }
      }
    """;
  }

  static const String cardBySlugQuery = r'''
    query CardBySlug($slug: String!) {
      cardBySlug(slug: $slug) {
        id
        title
        description
        pos
        card_number
        rework
        total_working_time
        start_time
        due_date
        board {
          id
          name
          description
        }
        list {
          id
          name
        }
        labels {
          id
          name
          color
        }
        users {
          id
          name
          email
          username
        }
        files {
          id
          name
        }
        checklist {
          id
          pos
          title
          checkpoints {
            id
            title
            status
            pos
          }
        }
      }
    }
  ''';


}