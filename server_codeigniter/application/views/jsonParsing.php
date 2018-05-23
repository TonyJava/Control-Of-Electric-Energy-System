<?php
  defined('BASEPATH') OR exit('No direct script access allowed');

  $dataJSON = array('code' => $code,
                'message' => $message,
                'data' => $data,
                'token' => $token);

  $this->output
    ->set_content_type('application/json')
    ->set_output(json_encode($dataJSON));
?>
