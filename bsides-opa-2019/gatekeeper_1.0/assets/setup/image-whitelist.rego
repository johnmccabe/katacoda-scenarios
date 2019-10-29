package kubernetes.admission  
  
import data.kubernetes.namespaces  

operations = {"CREATE", "UPDATE"}
valid_registries =  {
    "docker.io"
}

deny[msg] {
    kind = {"Deployment", "Job"}
    kind[input.request.kind.kind]
    operations[input.request.operation]
    registry = input.request.object.spec.template.spec.containers[_].image  
    name = input.request.object.metadata.name  
    namespace = input.request.object.metadata.namespace
    not reg_matches_any(registry,valid_registries)  
    msg = sprintf("invalid registry, namespace=%q, name=%q, registry=%q. Valid registries: %q", [namespace,name,registry,valid_registries])  
}

deny[msg] {  
    input.request.kind.kind == "Pod"
    operations[input.request.operation]
    registry = input.request.object.spec.containers[_].image  
    name = input.request.object.metadata.name  
    namespace = input.request.object.metadata.namespace
    not reg_matches_any(registry,valid_registries)  
    msg = sprintf("invalid registry, namespace=%q, name=%q, registry=%q. Valid registries: %q", [namespace,name,registry,valid_registries])  
}
  
reg_matches_any(str, patterns) {  
    reg_matches(str, patterns[_])  
}  
  
reg_matches(str, pattern) {  
    contains(str, pattern)  
}