/**
 * @flow strict-local
 */

// prettier-disable
/* eslint-disable */

import type { TurboModule } from 'react-native/Libraries/TurboModule/RCTExport';
import * as TurboModuleRegistry from 'react-native/Libraries/TurboModule/TurboModuleRegistry';

export interface Spec extends TurboModule {
  startThread: (threadId: Int, name: string) => void;
  stopThread: (threadId: Int) => void;
  postMessage: (threadId: Int, message: string) => void;
  // Events
  addListener: (eventName: string) => void;
  removeListeners: (count: number) => void;
}

export default TurboModuleRegistry.get<Spec>('RNWebWorker');
