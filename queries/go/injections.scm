; Interpret string consts beginning with dbq as sql
(
  const_spec
    name: ((identifier) @constName (#match? "^dbq"))
    value: (expression_list
      [
        (raw_string_literal (raw_string_literal_content) @injection.content (
          (#set! injection.language "sql")
          (#set! injection.combined)
        ))
        (interpreted_string_literal (interpreted_string_literal_content) @injection.content (
          (#set! injection.language "sql")
          (#set! injection.combined)
        ))
      ]
    )
)

