/// Enum representing the status of a video call
enum CallStatus {
  idle,        // Initial state
  initializing, // Setting up Agora engine
  ready,       // Engine ready, waiting to join
  connecting,  // Joining channel
  ringing,     // Waiting for other participant
  connected,   // Both participants in call
  reconnecting, // Network issues, attempting reconnect
  ended,       // Call ended normally
  failed,      // Call failed with error
}