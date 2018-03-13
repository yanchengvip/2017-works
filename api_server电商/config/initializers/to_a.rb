%w[String Integer Symbol TrueClass FalseClass].each { |klass| Object.const_get(klass).instance_eval { define_method :to_a, lambda { [self] } } }
