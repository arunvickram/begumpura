sub validate(&f, %form-data (:%data, *%), :$key, :$error-message, :$success-message) is export {
  if ?f(%data{$key}) { 
    return %form-data unless $success-message;
    
    return %(
      |%form-data,
      validations => %(
        |(%form-data<validations> || %()),
        $key => %(
          |(%form-data<validations>{$key} || %()),
          success => $success-message
        )
      )
    )
  } else {
    return %(
      |%form-data,
      validations => %(
        |(%form-data<validations> || %()),
        $key => %(
          |(%form-data<validations>{$key} || %()),
          errors => (
            |(%form-data<validations>{$key}<errors> || ()),
            $error-message
          )
        )
      )
    )
  }
}