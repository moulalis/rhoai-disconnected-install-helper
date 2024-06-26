#!/bin/bash

source rhoai-dih.sh

function main(){
  set_defaults
  parse_args "$@"
  branch_main=""
  if [ -z "$rhods_version" ]; then
    rhods_version=$(get_latest_rhods_version)
    file_name="$rhods_version.md"
    echo "Use latest RHODS version $rhods_version"  
  fi
  if is_rhods_version_greater_or_equal_to rhods-2.4; then
    echo "Cloning repositories"
    clone_all_repos
  else
    fetch_repository
    pushd "$repository_folder" || echo "Error: Directory $repository_folder does not exist"
    change_rhods_version
    popd || exit 1
    fetch_notebooks_repository
  fi
  image_set_configuration
  #test_current_branch_name "$rhods_version"
  cleanup

  # For rhoai-nightly
  branch_main="rhoai-main"
  file_name="$branch_main.md"
  echo "Use latest RHODS version $branch_main"  
  echo "Cloning repositories for main/master"
  clone_all_repos
  image_set_configuration
 # test_current_branch_name "$branch_main"
  cleanup

  
}

main "$@"
