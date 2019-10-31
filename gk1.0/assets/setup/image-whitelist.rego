package kubernetes.admission  
  
import data.kubernetes.namespaces  

kind = {"Deployment", "Job"}
operation = {"CREATE", "UPDATE"}
valid_registries =  {
    "docker.io/"
}
policy_name = "image-from-allowed-registry"

deny[msg] {
    kind_enforced
    operation_enforced
    image_from_valid_registry[msg]

}

reg_matches_any(str, patterns) {  
    reg_matches(str, patterns[_])  
}  
  
reg_matches(str, pattern) {  
    contains(str, pattern)  
}

# Extract images from Pods
container_images[c] {
    c := input.request.object.spec.containers[_].image
}

# Extract images from Deployments
container_images[c] {
    c := input.request.object.spec.template.spec.containers[_].image
}

# Check if kind recognised
kind_enforced {
    kind[input.request.kind.kind]
}

# Check if operation recognised
operation_enforced {
    operation[input.request.operation]
}

# Image from allowed registry
image_from_valid_registry[msg] {
    some image
    container_images[image]
    not reg_matches_any(image,valid_registries)
    msg = sprintf("[%s violation] %s %s in namespace %s pulling image from invalid registry %s. Valid registries are: %s", [policy_name, input.request.object.kind, input.request.object.metadata.name, input.request.object.metadata.namespace, image, valid_registries])  
}