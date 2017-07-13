define ->

  explain:

    message:
      success: '[s] {{message}}'
      error: '[e] {{message}}'

    error:
      unknown:
        '[e] Something went wrong'
      not_found:
        '[e] Item Was Not Found'
      mobile_only:
        '[w] Currently this feature is only available on mobile'
      coming_soon:
        '[w] This function will be available soon.'
      messaging_coming_soon:
        '[w] Messaging function will be available soon.'

    login:
      failed:
        '[e] Failed to login'
      unauthorized:
        '[e] Invalid Credentials'
      abscent:
        '''[e] Account with provided email does not exists.
          You have to Sign Up first.'''

    user:
      signup:
        confirm_email:
          '''[s] Your Path To Fitness Starts Now.
            Please check your email to confirm your account.'''
      password:
        changed:
          '[s] Password was successfully changed'
        invalid_token:
          '[e] Reset password token is invalid'
      invitation:
        sent:
          '[s] Invitation successfully sent'
      confirmation:
        sent:
          '[s] Confirmation successfully sent'
      account_type:
        changed:
          '[s] Account type successfully changed'
        not_selected:
          '[w] Please select your Account Type'
      certificate:
        declined:
          '[e] Your Fitness Certification has been rejected,
            please email support@gymcloud.com for further assistance'
        uploaded:
          "[s] Your certification has been uploaded and is now under review.
          We'll notify you if there are any issues. Continue using GymCloud."
      profile:
        updated:
          '[s] Your profile has been successfully updated'

    client:
      added:
        '[s] Client successfully saved'
      pro_exists:
        '[s] Your Pro is already registered, logging you in.'

    item:
      added:
        '[s] New item added'
      deleted:
        '[s] Item was deleted'
      not_deleted:
        '[e] Item was not deleted'
      updated:
        '[s] {{type}} was updated'
      not_updated:
        '[e] {{type}} was not updated'
      not_selected:
        '[e] No item was selected'
      duplicated:
        '[s] Item was moved'
      moved:
        '[s] {{item}} is moved to {{folder}}'
      added_to_library:
        '[s] {{type}} added to library'
      client:
        assigned:
          '[s] This {{type}} is assigned to client'
        unassigned:
          '[s] This {{type}} is unassigned from client'
      client_group:
        assigned:
          '[s] This {{type}} is assigned to group'
        unassigned:
          '[s] This {{type}} is unassigned from group'

    folder:
      added:
        '[s] New folder added'

    workout_exercise:
      added:
        '[s] Workout was added'

    exercise:
      updated:
        '[s] Exercise was updated'
      deleted:
        '[s] Exercise was deleted'

    workout:
      deleted:
        '[s] Workout was deleted'

    program:
      updated:
        '[s] Program was updated'
      not_updated:
        '[e] Program was not updated'
      deleted:
        '[s] Program was deleted'

    program_workout:
      saved:
        '[s] Workout was saved to your library'

    video:
      deleted:
        '[s] Video was deleted'
      updated:
        '[s] Video was updated'
      uploaded:
        '[s] Video is being processing. It will be available in 2 minutes'
      invalid_type:
        '[e] Invalid File Type'
      search:
        error:
          '[e] Videos search error'

    week:
      added:
        '[s] Week was added'
      deleted:
        '[s] Week {{name}} was deleted'

    client_groups:
      empty: 'No available client groups'

    personal_best:
      added: 'New personal best added'

    personal_program:
      empty:
        'Program should contain some workouts'

    personal_workout:
      empty:
        'Workout should contain some exercises'
