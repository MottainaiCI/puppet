class mottainai (
  Hash[String, Hash]  $agents = {},
) {

  $agents.each |$name, $params| {
    mottainai::agent { $name:
      * => $params,
    }
  }

}
