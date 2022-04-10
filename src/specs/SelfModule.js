/**
 * @flow strict-local
 */

// prettier-disable
/* eslint-disable */

import type { TurboModule } from 'react-native/Libraries/TurboModule/RCTExport';
import * as TurboModuleRegistry from 'react-native/Libraries/TurboModule/TurboModuleRegistry';

export interface Spec extends TurboModule {
  postMessage: (threadId: Int, message: string) => void;
  postError: (threadId: Int, message: string) => void;
}

export default TurboModuleRegistry.get<Spec>('SelfModule');
