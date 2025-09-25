
INSTANCE_ID="i-3214dsf234f"

# Get the public ip of the instance specified
ipv4_address=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query 'Reservations[0].Instances[0].PublicIpAddress' --output text)

# Path to .env.docker
file_to_find=../frontend/.env.docker

# Check the current frontendurl in the env
current_url=$(cat $file_to_find)

# Update the env if current_url and the frontendurl in env don't match
if [[ "$current_url" != "VITE_API_PATH=\"http://${ipv4_address}:31000\"" ]]; then
  if [ -f "$file_to_find" ]; then
    sed -i -e "s|VITE_API_PATH.*|VITE_API_PATH=\"http://${ipv4_address}:31000\"|g" $file_to_find
  else
    echo "ERROR: File not found"
  fi
fi
